Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab1DBBDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:03:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50536 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753563Ab1DBBDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:03:46 -0400
Date: Sat, 2 Apr 2011 10:03:56 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Fix the argument of calling
 regulator_mode_constrain
Message-ID: <20110402010355.GB25424@opensource.wolfsonmicro.com>
References: <1301653525.22820.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301653525.22820.1.camel@phoenix>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 06:25:25PM +0800, Axel Lin wrote:
> The second parameter of regulator_mode_constrain takes a pointer.
> 
> This patch fixes below warning:
> drivers/regulator/core.c: In function 'regulator_set_mode':
> drivers/regulator/core.c:2014: warning: passing argument 2 of 'regulator_mode_constrain' makes pointer from integer without a cast
> drivers/regulator/core.c:200: note: expected 'int *' but argument is of type 'unsigned int'

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
