Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0HTIfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:35:12 -0400
Received: from atlantide.nekhem.com ([213.92.23.148]:40555 "EHLO
	atlantide.nekhem.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0HTIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:35:10 -0400
X-Greylist: delayed 1177 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Aug 2010 04:35:10 EDT
Subject: On omap3evm kernel 2.6.34+ doesn't boot (solved)
From: Giuseppe Pagano <giuseppe.pagano@fastwebnet.it>
Reply-To: giuseppe.pagano@fastwebnet.it
To: linux-kernel@vger.kernel.org
Cc: source@mvista.com
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 Aug 2010 10:08:43 +0200
Message-ID: <1282291723.3725.13.camel@anam.i-m3d.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm developing on an arm OMAP3530 based board, machine omap3evm.

Starting from kernel versione 2.6.34 machine doesn't boot (On the serial
console I can see just the uboot message, afther the console freese,
anche there is no output from the kernel).

I have found that changing this line in 
arch/arm/plat-omap/include/plat/uncompress.h

-               DEBUG_LL_OMAP2(1, omap3evm);
+               DEBUG_LL_OMAP3(3, omap3evm);

solves the problem. 

I thing this is a bug, so I write this email.

Thanks
Giuseppe

