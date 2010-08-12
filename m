Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531Ab0HLVGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:06:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40865 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab0HLVG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mJjDuyRHn0LnaJa+7iExN0PLrNpoA/ZhsxLxWYCcFPBz1HIUxAyOY55D/FNjk/bfrp
         RY2dhN3jY6FwFXIpDQngi50/RkC+j/sWcERPe1Fj8MEuIaYyBRtRVRm8KDvv3Dmd7yGK
         /RI2BpwmhszdP3yH5+/GnE6ovjAvCVYL9dh2k=
Message-ID: <4C64624E.7040002@gmail.com>
Date: Thu, 12 Aug 2010 23:06:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: mmotm 2010-08-11 - audio volume issues
References: <201008112340.o7BNenDe021017@imap1.linux-foundation.org> <5043.1281639572@localhost>
In-Reply-To: <5043.1281639572@localhost>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 08:59 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 11 Aug 2010 16:10:49 PDT, akpm@linux-foundation.org said:
>> The mm-of-the-moment snapshot 2010-08-11-16-10 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
> 
> Something appears to be borked in the ALSA arena.  There's no actual volume coming
> out of the system, and 'alsamixer' is insisting that the volume slider only goes from 0
> to 10% or so, no further.  However, experimentation shows that the volume slider
> in 'xine' *does* affect the 'Amp-Out vals' lines, and alsamixer has *no* effect on
> what 'Amp-Out vals' lists.
> 
> A diff of alsa-info.sh for the two kernels shows them being identical, so I'm only
> attaching one copy.
> 
> It may be the weekend before I find time to do a bisection of this.

Didn't you (like some other people) get into the state where pulseaudio
doesn't work? It chooses as an output a dummy driver automatically, then
you can change volume, play sound, but actually it all goes to /dev/null.

It took me a while before I figured out that it's a "dummy" driver I
have in pulseaudio.

regards,
-- 
js
