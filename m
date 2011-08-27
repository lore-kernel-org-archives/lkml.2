Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab1H0Gc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 02:32:27 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46202 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1H0Gc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 02:32:26 -0400
Date: Fri, 26 Aug 2011 23:32:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH] Input: adp5588-keys - remove incorrect modalias
Message-ID: <20110827063220.GD29434@core.coreip.homeip.net>
References: <1314268238.2663.1.camel@phoenix>
 <544AC56F16B56944AEC3BD4E3D59177146E6D0708C@LIMKCMBX1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544AC56F16B56944AEC3BD4E3D59177146E6D0708C@LIMKCMBX1.ad.analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 11:43:53AM +0100, Hennerich, Michael wrote:
> Axel Lin wrote on 2011-08-25:
> > From 2b642fd34e59291764f5149f083d84760d8b41b2 Mon Sep 17 00:00:00 2001
> > From: Axel Lin <axel.lin@gmail.com>
> > Date: Thu, 25 Aug 2011 18:26:56 +0800
> > Subject: [PATCH] Input: adp5588-keys - remove incorrect modalias
> >
> > For i2c drivers, we should use "i2c:" prefix for modalias.
> > MODULE_DEVICE_TABLE will setup the modulalias for us,
> > thus adding a MODULE_ALIAS here seems redundant.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Michael Hennerich <michael.hennerich@analog.com>

Applied, thanks Axel.

-- 
Dmitry
