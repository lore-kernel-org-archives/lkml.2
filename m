Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1CQTCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:02:24 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:45233 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754725Ab1CQTCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:02:21 -0400
Message-ID: <4D825AB9.4030406@example.com>
Date: Thu, 17 Mar 2011 20:02:17 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>, benh@debian.org
Subject: Re: Where to get the network NIC's firmware? rtl_nic/rtl8105e-1.fw
References: <201103101209.p2AC9YdZ014233@violet.fr.zoreil.com> <20110316202220.GA14741@electric-eye.fr.zoreil.com>
In-Reply-To: <20110316202220.GA14741@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6537537811197948314
X-Ovh-Remote: 178.36.24.230 (178-36-24-230.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.03.2011 21:22, Francois Romieu wrote:
> You can get it there:
>
> http://git.kernel.org/pub/scm/linux/kernel/git/romieu/linux-firmware.git
> git://git.kernel.org/pub/scm/linux/kernel/git/romieu/linux-firmware.git
>
> It has already been submitted to the maintainer of linux-firmware.

Hello,

The problem persists, I have on disk:

# ls /lib/firmware/rtl_nic/
rtl8105e-1.fw  rtl8168d-1.fw  rtl8168d-2.fw  rtl8168e-1.fw  rtl8168e-2.fw

And my NIC doesn't work. What do you mean saying that I can get it 
there? How can I contact the maintainer?

Please, help, I cannot test new kernels.

Regards,

Piotr Hosowicz

-- 
Na przyjêciu ch³opak pyta blondynkê:
- Czy mogê ciê prosiæ do walca?
- Zg³upia³e¶? To ju¿ nie mia³e¶ czym przyjechaæ?
NP: Banda Do Sol - Fabito
NB: 2.6.38-git3
