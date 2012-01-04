Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2ADEfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 23:35:38 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50037 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab2ADEff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 23:35:35 -0500
Date: Wed, 4 Jan 2012 08:35:30 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH] power: lp8727 - add supported i2c functionality check
 routine
Message-ID: <20120104043530.GA26010@oksana.dev.rtsoft.ru>
References: <B567DBAB974C0544994013492B949F8E380F619DE2@EXMAIL03.scwf.nsc.com>
 <20111012194927.GA9239@oksana.dev.rtsoft.ru>
 <B567DBAB974C0544994013492B949F8E38123AC1B6@EXMAIL03.scwf.nsc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B567DBAB974C0544994013492B949F8E38123AC1B6@EXMAIL03.scwf.nsc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 09:43:06PM -0800, Kim, Milo wrote:
> Hi, Anton
> 
> I send the patch for lp8727 charger driver.
> 
> Signed-off-by: Woogyom Kim <milo.kim@ti.com>
> 
> From c72a8a461d19ace81d9d092e8a23de741dd2144f Mon Sep 17 00:00:00 2001
> From: Milo(Woogyom) Kim <milo.kim@ti.com>
> Date: Fri, 18 Nov 2011 14:30:59 +0900
> Subject: [PATCH] power : lp8727 - add supported i2c functionality check routine
> 
> lp8727 i2c r/w functions are based on SMBUS I2C BLOCK.
> So the driver needs to check whether i2c bus supports this functionality or not.
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
