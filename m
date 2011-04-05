Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1DEJH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 05:07:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37063 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1DEJH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 05:07:28 -0400
Subject: Re: [PATCH] regulator: Fix the argument of calling
 regulator_mode_constrain
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1301653525.22820.1.camel@phoenix>
References: <1301653525.22820.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 10:07:18 +0100
Message-ID: <1301994438.14075.112.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 18:25 +0800, Axel Lin wrote:
> The second parameter of regulator_mode_constrain takes a pointer.
> 
> This patch fixes below warning:
> drivers/regulator/core.c: In function 'regulator_set_mode':
> drivers/regulator/core.c:2014: warning: passing argument 2 of 'regulator_mode_constrain' makes pointer from integer without a cast
> drivers/regulator/core.c:200: note: expected 'int *' but argument is of type 'unsigned int'
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

Thanks

Liam


