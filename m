Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0EQQIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:08:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50492 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753099Ab0EQQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:08:11 -0400
Date: Mon, 17 May 2010 09:08:15 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar R Iyer <sundar.iyer@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/1] regulator: return set_mode is same mode is
 requested
Message-ID: <20100517160813.GA6547@opensource.wolfsonmicro.com>
References: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
 <20100517144411.GD5257@opensource.wolfsonmicro.com>
 <1274108214.20589.28.camel@bnru01>
 <1274109402.20589.39.camel@bnru01>
 <20100517153431.GA6218@opensource.wolfsonmicro.com>
 <1274111688.20589.54.camel@bnru01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274111688.20589.54.camel@bnru01>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 09:24:48PM +0530, Sundar R Iyer wrote:

> >From bad0d5eb51ef84be5b100e3dd0f5a590ea0529b6 Mon Sep 17 00:00:00 2001
> From: Sundar R Iyer <sundar.iyer@stericsson.com>
> Date: Fri, 14 May 2010 15:14:17 +0530
> Subject: [PATCH 1/1] regulator: return set_mode when same mode is requested
> 
> save I/O costs by returning when the same mode is
> requested for the regulator

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
