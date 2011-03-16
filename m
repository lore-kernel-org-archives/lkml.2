Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1CPW55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 18:57:57 -0400
Received: from 31.mail-out.ovh.net ([213.186.62.10]:37161 "HELO
	31.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751859Ab1CPW5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 18:57:54 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 18:57:53 EDT
Message-ID: <4D813EDB.20307@example.com>
Date: Wed, 16 Mar 2011 23:51:07 +0100
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
X-Ovh-Tracer-Id: 4529776800600519066
X-Ovh-Remote: 178.36.184.107 (178-36-184-107.adsl.inetia.pl)
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

Thanks a lot, you saved me hours of searching.

Regards,

Piotr Hosowicz
-- 
Miss World 2006: Jestem szczê¶liwa, ¿e mogê wspaniale uczestniczyæ w
prze¿yciu najpiêkniejszych kobiet tutaj w Warszawie, gdzie Jan Pawe³ II,
papie¿, w Polsce, sk±d pochodzi. Spotka³am siê z Ko¶cio³em Mariackim
w Krakowie, który ciep³o ludzi i wielka przyja¼ñ. Po³owa mojego serca
zostanie w Polsce, a druga po³owa pojedzie ze mn± do mojego kraju.
NP: Phideaux - waiting for the axe to fall
NB: 2.6.38-git2
