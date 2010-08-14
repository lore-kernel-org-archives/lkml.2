Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934679Ab0HNJ5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 05:57:42 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:56275 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934660Ab0HNJ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 05:57:41 -0400
Date: Sat, 14 Aug 2010 15:27:34 +0530
From: Sundar R IYER <sundar.iyer@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dan Carpenter <error27@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] regulator/ab8500: move dereference below the check for
 NULL
Message-ID: <20100814095733.GA30094@bnru01.bnr.st.com>
References: <20100814090316.GX645@bicker>
 <64F33A1C-EB54-4DFF-85C7-6796CFF475BA@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <64F33A1C-EB54-4DFF-85C7-6796CFF475BA@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 11:36:13 +0200, Mark Brown wrote:
> On 14 Aug 2010, at 10:03, Dan Carpenter wrote:
> 
> > I moved the dereference of "ab8500" below the check for NULL.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanx!

Regards,
Sundar
