Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276Ab0FKNJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:09:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33065 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab0FKNJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:09:16 -0400
Date: Fri, 11 Jun 2010 15:08:13 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] drivers: regulator: add Maxim 8998 driver
In-reply-to: <20100611130236.GA4650@rakim.wolfsonmicro.main>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com,
       "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Message-id: <007301cb0967$28dec280$7a9c4780$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcsJZoJxawTyG9AiQJO0PCPbceplOwAAG+5A
References: <1276239765-26234-1-git-send-email-m.szyprowski@samsung.com>
 <20100611105823.GA17546@rakim.wolfsonmicro.main>
 <007201cb0965$542b6cb0$fc824610$%szyprowski@samsung.com>
 <20100611130236.GA4650@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, June 11, 2010 3:03 PM Mark Brown wrote:

> On Fri, Jun 11, 2010 at 02:55:07PM +0200, Marek Szyprowski wrote:
> > On Friday, June 11, 2010 12:58 PM Mark Brown wrote:
> 
> > > A few things in the code make it look like the driver should be using
> > > the MFD framework - there's references in here for things like a
> battery
> > > charger which should be being supported via the power subsystem, for
> > > example.
> 
> > You are right, this chip is really complicated and should work with more
> > than one kernel subsystem. However in this initial version of the driver
> > we tried to make it as simple as possible. It can be converted to MFD
> > framework later, but if you want we can prepare this driver as MFD from
> > the beginning.
> 
> It makes life a lot easier to start off with the MFD, even if you only
> add a single function driver initially.  Otherwise you end up with cross
> tree hassle trying to deal with the transition later on.

Ok, we will start off with MFD version then.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


