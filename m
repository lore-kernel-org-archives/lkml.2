Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab0JUVmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:42:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44703 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab0JUVm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=L6geCJH5GKD/AfJ4/QrWR4/dvyQPD2XYoRztzTbXnaSAQHdlyDcf508q0FmI6UHYnH
         2ASImm81HU1j+dMOCOkPgmP7Z4HV1YLiOZlbDiZPZHhmOpClIytcUmwc0Ltfucz95+ZO
         45IhCZVhfU6RsCwprOC2JFPOe8Cf/VwDzkL+Q=
Message-ID: <4CC0B3C1.9010106@gmail.com>
Date: Thu, 21 Oct 2010 23:42:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        clemens@ladisch.de, Jaroslav Kysela <perex@perex.cz>,
        Colin Guthrie <gmane@colin.guthr.ie>, alsa-devel@alsa-project.org
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>	<4CBFEE94.7020103@gmail.com>	<s5hlj5sc7do.wl%tiwai@suse.de>	<4CBFF25C.2080908@gmail.com>	<s5hfww0c6oj.wl%tiwai@suse.de>	<4CC085F5.9070905@gmail.com>	<s5heibjxsi4.wl%tiwai@suse.de>	<4CC092BC.9060504@gmail.com>	<s5h8w1rxrl3.wl%tiwai@suse.de>	<5220.1287692957@localhost>	<s5h39rzclx3.wl%tiwai@suse.de>	<8089.1287696264@localhost> <s5hsjzzb5cf.wl%tiwai@suse.de>
In-Reply-To: <s5hsjzzb5cf.wl%tiwai@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 11:31 PM, Takashi Iwai wrote:
> OK.  Maybe someone else can check it meanwhile.

Someone else rebooted the 13th time today and checked :):
$ rpm -q `rpmqpack |egrep 'alsa|asound'|sort`
alsa-1.0.22.git20101018-1.1.x86_64
alsa-firmware-1.0.23-3.7.noarch
alsa-oss-1.0.17-31.4.x86_64
alsa-plugins-1.0.23-4.5.x86_64
alsa-plugins-pulse-1.0.23-4.5.x86_64
alsa-plugins-pulse-32bit-1.0.23-4.5.x86_64
alsa-plugins-32bit-1.0.23-4.5.x86_64
alsa-utils-1.0.23-4.5.x86_64
libasound2-1.0.22.git20101018-1.1.x86_64
libasound2-32bit-1.0.23-6.5.x86_64

No success. I still need the revert.

regards,
-- 
js
