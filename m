Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab2IKAJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 20:09:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42100 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063Ab2IKAJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 20:09:35 -0400
Date: Tue, 11 Sep 2012 08:09:27 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Luis Gonzalez Fernandez <luisgf@gmail.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] regulator: Fix incorrect casting in
 tps6230-regulator.c
Message-ID: <20120911000925.GC30699@opensource.wolfsonmicro.com>
References: <1347310409-25976-1-git-send-email-luisgf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347310409-25976-1-git-send-email-luisgf@gmail.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:53:29PM +0200, Luis Gonzalez Fernandez wrote:
> linux-3.6/drivers/regulator/tps62360-regulator.c: In function ‘tps62360_probe’:
> linux-3.6/drivers/regulator/tps62360-regulator.c:364:13: warning: cast from poi$
> 
> Fix incorrect cast in tps62360_probe() function.

This fix isn't at all obvious and the warning doesn't show up for me.
In general you need to supply some words explaining what you're doing,
simply pasting a copy of an error message doesn't explain why your new
code is good.
