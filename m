Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1L2J1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 04:27:19 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36120 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab1L2J1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 04:27:16 -0500
Message-ID: <4EFC3270.9020109@monstr.eu>
Date: Thu, 29 Dec 2011 10:27:12 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH 1/4] block: xsysace: Don't use NO_IRQ
References: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
In-Reply-To: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
> Drivers shouldn't use NO_IRQ. Microblaze and PPC
> define NO_IRQ as 0 and this reference will be removed
> in near future.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Rob Herring <rob.herring@calxeda.com>
> CC: Ryan Mallon <rmallon@gmail.com>
> ---
>  drivers/block/xsysace.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

Grant: Can you give me your ACK?

Thanks,
Michal
-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
