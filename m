Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0HKHUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:20:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47506 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab0HKHUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:20:42 -0400
Date: Wed, 11 Aug 2010 08:20:14 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, arnd.bergmann@de.ibm.com
Subject: Re: [PATCH] arm: fix versatile boot hang (seen with qemu)
Message-ID: <20100811072014.GA14306@flint.arm.linux.org.uk>
References: <1281493191.2955.42.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281493191.2955.42.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 07:19:51PM -0700, john stultz wrote:
> Hey Russell,
> 
> 	I have been having troubles getting the 2.6.35 kernel to boot in my
> qemu-system-arm environment.

It's a qemu bug.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
