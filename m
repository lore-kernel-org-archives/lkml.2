Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1GSGOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:14:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60958 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1GSGOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:14:21 -0400
Date: Tue, 19 Jul 2011 09:12:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Ravishankar <ravishankarkm32@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 1/2 v3] Staging: comedi: fix printk() issue in
 adv_pci1710.c
Message-ID: <20110719061226.GF4010@shale.localdomain>
References: <1311054656-14207-1-git-send-email-ravishanakarkm32@gmail.com>
 <4E251F1F.2080406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E251F1F.2080406@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 04:07:27PM +1000, Ryan Mallon wrote:
> This still isn't correct. The initial printk (KERN_INFO above) has
> no trailing newline. Here you are almost doing it correctly, except
> that you are adding an extra newline. This error message will look
> like this:
> 
> comedi0: adv_pci1710:
> comedi0: adv_pci1710: Allocation failed
> 

Actually kmalloc() prints an message with a stack trace on failure as
well so that would go in the middle, just before the first newline.

regards,
dan carpenter
