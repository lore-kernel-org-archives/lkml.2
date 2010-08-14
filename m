Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0HNJgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 05:36:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50751 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752229Ab0HNJgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 05:36:16 -0400
Subject: Re: [patch] regulator/ab8500: move dereference below the check for NULL
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20100814090316.GX645@bicker> (sfid-20100814_100351_685395_0B6B8F07)
Date: Sat, 14 Aug 2010 10:36:13 +0100
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <64F33A1C-EB54-4DFF-85C7-6796CFF475BA@opensource.wolfsonmicro.com>
References: <20100814090316.GX645@bicker> (sfid-20100814_100351_685395_0B6B8F07)
To: Dan Carpenter <error27@gmail.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Aug 2010, at 10:03, Dan Carpenter wrote:

> I moved the dereference of "ab8500" below the check for NULL.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
