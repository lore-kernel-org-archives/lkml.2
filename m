Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0KSLTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:19:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51080 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753390Ab0KSLTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:19:01 -0500
Date: Fri, 19 Nov 2010 11:18:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: fix kernel-doc for
 set_consumer_device_supply
Message-ID: <20101119111859.GG7233@rakim.wolfsonmicro.main>
References: <20101118150226.d0614b85.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118150226.d0614b85.randy.dunlap@oracle.com>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:02:26PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc warning for set_consumer_device_supply():
> 
> Warning(drivers/regulator/core.c:912): missing initial short description on line:
>  * set_consumer_device_supply: Bind a regulator to a symbolic supply

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
