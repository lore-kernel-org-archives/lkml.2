Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0JUHlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:41:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0JUHlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ts1J1xfLGLci++lPi4Xx/tc7immh/njA4zfpeV8f2XgIDici596L3fggtTYPRZw897
         JjecLf+SPcSD6QX/eiap5kQFCA9xTOPVnmkbQYI9S7b+WbmcMFVs/VjPpm/+ZOU4uJQ3
         GzVI5Lsww434prGvMeLJuIOL8ZdC4WMq8AL+s=
Message-ID: <4CBFEE94.7020103@gmail.com>
Date: Thu, 21 Oct 2010 09:41:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, clemens@ladisch.de,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org
Subject: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
In-Reply-To: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 12:01 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-10-20-15-01 has been uploaded to

Hi, I've lost sound with my intel hda (sigmatel) in this release
(regression against mmotm 2010-10-13-17-13).

All outputs were silented at level 0 after reboot, but even after
setting them non-zero in alsamixer -D hw, no sound can be heard by:
mplayer -ao alsa:device=hw /usr/share/sounds/alsa/Front_Center.wav

I don't knwo if it's related, but aplay complains like (even if I pass
-c 2):
aplay -D hw /usr/share/sounds/alsa/Front_Center.wav
Playing WAVE '/usr/share/sounds/alsa/Front_Center.wav' : Signed 16 bit
Little Endian, Rate 48000 Hz, Mono
aplay: set_params:1065: Channels count non available


alsa-info:
http://www.alsa-project.org/db/?f=a7a09703bcc8c43386c87a984e513ce35fc91ca4

regards,
-- 
js
