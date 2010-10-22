Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0JVLKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:10:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34305 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0JVLKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DKkv319tjhSu5iiyCBU+1hrX1RxlVHJvl/8q3Uu5H8HGjnkMRDkit/pjJViram/3oc
         /2UO9cIO0UjVlz++WXIDhldU2JSdwAWMN4sp/zst1HUsGbe2C2XdakLmivsfr/qnh0iq
         O38eMEBCr72/ZK1oAWBirq8KdtreGzKaN1DOY=
Message-ID: <4CC17134.2040706@gmail.com>
Date: Fri, 22 Oct 2010 13:10:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Colin Guthrie <gmane@colin.guthr.ie>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, clemens@ladisch.de,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>	<4CBFEE94.7020103@gmail.com>	<s5hlj5sc7do.wl%tiwai@suse.de>	<4CBFF25C.2080908@gmail.com>	<s5hfww0c6oj.wl%tiwai@suse.de>	<4CC085F5.9070905@gmail.com>	<s5heibjxsi4.wl%tiwai@suse.de>	<4CC092BC.9060504@gmail.com>	<s5h8w1rxrl3.wl%tiwai@suse.de>	<5220.1287692957@localhost>	<s5h39rzclx3.wl%tiwai@suse.de>	<8089.1287696264@localhost>	<s5hsjzzb5cf.wl%tiwai@suse.de>	<4CC0B3C1.9010106@gmail.com>	<4CC14F4E.4090509@colin.guthr.ie>	<s5hmxq6bnwj.wl%tiwai@suse.de>	<4CC156ED.8000104@gmail.com>	<s5hiq0ubm5e.wl%tiwai@suse.de>	<4CC15D40.9070606@gmail.com> <s5h8w1qbk18.wl%tiwai@suse.de>
In-Reply-To: <s5h8w1qbk18.wl%tiwai@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 12:26 PM, Takashi Iwai wrote:
> I updated the version number and triggered rebuilds on OBS
> multimedia:audio:snapshot packages.  To be sure, install alsa.rpm,
> libasound2.rpm and alsa-utils.rpm later from the project.
> Now they should have version 1.0.23.git*.

alsa-1.0.23.git20101018-1.1.x86_64
alsa-firmware-1.0.23-3.7.noarch
alsa-oss-1.0.17-31.4.x86_64
alsa-plugins-1.0.23-4.5.x86_64
alsa-plugins-pulse-1.0.23-4.5.x86_64
alsa-plugins-pulse-32bit-1.0.23-4.5.x86_64
alsa-plugins-32bit-1.0.23-4.5.x86_64
alsa-utils-1.0.23.git20101022-3.1.x86_64
libasound2-1.0.23.git20101018-1.1.x86_64
libasound2-32bit-1.0.23-6.5.x86_64

> Also, you don't need to check the reverted kernel.  The only
> interesting thing is to see whether the dB range brokeness is fixed
> by alsa-lib update.

With patch not reverted (i.e. no sound):
http://www.alsa-project.org/db/?f=378efb40f8c5b1d6204e93221512506e7bb7b061

regards,
-- 
js
