Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0JVJSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:18:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63759 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab0JVJSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ArHrjNluHyyEXN8x911lC54UMdSRouNggdhtHrp53gcCOnZO0e9nkQZJDVkDT7tApr
         9GLGqAV7aPfQESGPQySGrMTqzyd197fA5G+mBypYa3zudjYxzIr32ppG98lYzczx6Qhz
         PrwEHsnDFakEJYfB/Ca6Cy3P7H7ee3qzgq+M4=
Message-ID: <4CC156ED.8000104@gmail.com>
Date: Fri, 22 Oct 2010 11:18:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Colin Guthrie <gmane@colin.guthr.ie>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, clemens@ladisch.de,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>	<4CBFEE94.7020103@gmail.com>	<s5hlj5sc7do.wl%tiwai@suse.de>	<4CBFF25C.2080908@gmail.com>	<s5hfww0c6oj.wl%tiwai@suse.de>	<4CC085F5.9070905@gmail.com>	<s5heibjxsi4.wl%tiwai@suse.de>	<4CC092BC.9060504@gmail.com>	<s5h8w1rxrl3.wl%tiwai@suse.de>	<5220.1287692957@localhost>	<s5h39rzclx3.wl%tiwai@suse.de>	<8089.1287696264@localhost>	<s5hsjzzb5cf.wl%tiwai@suse.de>	<4CC0B3C1.9010106@gmail.com>	<4CC14F4E.4090509@colin.guthr.ie> <s5hmxq6bnwj.wl%tiwai@suse.de>
In-Reply-To: <s5hmxq6bnwj.wl%tiwai@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 11:02 AM, Takashi Iwai wrote:
> unpatched alsa-lib.  Jiri, could you regenerate alsa-info output with
> the fixed alsa-lib packages?  With the fixed alsa-lib, the dB value
> should be given correctly.

Sure, but I don't know which version you want, so with the patch reverted:
http://www.alsa-project.org/db/?f=4efd8e3b74a51adbd014a85052a83b4a3c5bd9fc

with the patch NOT reverted:
http://www.alsa-project.org/db/?f=e619bba74bb9ea007c2e5314761411a658ff677b

regards,
-- 
js
