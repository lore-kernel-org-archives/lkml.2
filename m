Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0JUSeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 14:34:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56086 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab0JUSef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 14:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NPU3EAMwQqwihqs6RO8mfSkFBJ55ZzgEo4T2xr3YEGK+Jn5pTOIXybrz8Hk54zHuRR
         wJ8Q5lSVmV1oRIdzLIKYJ9e5hUYCmkoQdYsDu9WERTuPVjny0kP4x2nkhljsOb8CpQzX
         GoVSD/jo0lBP/OyBZ14BBTm31824UHba+TGtY=
Message-ID: <4CC085F5.9070905@gmail.com>
Date: Thu, 21 Oct 2010 20:27:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, clemens@ladisch.de,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        Valdis.Kletnieks@vt.edu
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>	<4CBFEE94.7020103@gmail.com>	<s5hlj5sc7do.wl%tiwai@suse.de>	<4CBFF25C.2080908@gmail.com> <s5hfww0c6oj.wl%tiwai@suse.de>
In-Reply-To: <s5hfww0c6oj.wl%tiwai@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 10:05 AM, Takashi Iwai wrote:
> At Thu, 21 Oct 2010 09:57:16 +0200,
> Jiri Slaby wrote:
>> BUT, when I run pulse and it suspends the device (or whatever), all the
>> levels get down to 0 back again. When I raise it and run mplayer, it
>> gets to 0 immediately. If I raise it gets to 0 when mplayer finishes and
>> pulse writes 'protocol-native.c: Connection died.'. It never raises
>> automatically. And if I raise it during playback, nothing plays at all.
> 
> Hrm, I don't remember any so critical changes done recently in the
> sound tree.  The only possibly affecting commits are:
> 
>   commit 1cc9e8f4c45999e6069f41521d9d391eeeccc3b3
>     ALSA: hda - Fix codec muted after rebooting from Windows
> 
>   commit de8c85f7840e5e29629de95f5af24297fb325e0b
>     ALSA: HDA: Sigmatel: work around incorrect master muting

Reverting this one helps.

thanks,
-- 
js
