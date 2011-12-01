Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1LATK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:10:56 -0500
Received: from void.printf.net ([89.145.121.20]:50785 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab1LATKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:10:54 -0500
From: Chris Ball <cjb@laptop.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Micha <mirq-linux@rere.qmqm.pl>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: convert drivers/mmc/host/* to use module_platform_driver()
References: <1322283343.14278.2.camel@phoenix>
Date: Thu, 01 Dec 2011 14:11:00 -0500
In-Reply-To: <1322283343.14278.2.camel@phoenix> (Axel Lin's message of "Sat,
	26 Nov 2011 12:55:43 +0800")
Message-ID: <87borsjeez.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel, Micha,

On Fri, Nov 25 2011, Axel Lin wrote:
> This patch converts the drivers in drivers/mmc/host/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.

This makes cb710_mmc unhappy:

/home/cjb/git/mmc/drivers/mmc/host/cb710-mmc.c:783:1: warning: data definition has no type or storage class [enabled by default]
/home/cjb/git/mmc/drivers/mmc/host/cb710-mmc.c:783:1: warning: type defaults to ‘int’ in declaration of ‘module_platform_driver’ [-Wimplicit-int]
/home/cjb/git/mmc/drivers/mmc/host/cb710-mmc.c:783:1: warning: parameter names (without types) in function declaration [enabled by default]
/home/cjb/git/mmc/drivers/mmc/host/cb710-mmc.c:773:31: warning: ‘cb710_mmc_driver’ defined but not used [-Wunused-variable]


- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
