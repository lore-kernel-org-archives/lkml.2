Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0FPFOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:14:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64227 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0FPFOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:14:20 -0400
Date: Wed, 16 Jun 2010 07:13:13 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v2] drivers: regulator: add Maxim 8998 driver
In-reply-to: <20100615131452.GF14510@rakim.wolfsonmicro.main>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, sameo@linux.intel.com,
       "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Message-id: <010f01cb0d12$a18484a0$e48d8de0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcsMjMMyORNOmvY0QmWzUsTyyeOR9wAg/wTQ
References: <1276603388-8022-1-git-send-email-m.szyprowski@samsung.com>
 <20100615121226.GE14510@rakim.wolfsonmicro.main>
 <00d801cb0c87$aae7b020$00b71060$%szyprowski@samsung.com>
 <20100615131452.GF14510@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, June 15, 2010 3:15 PM Mark Brown wrote:

> On Tue, Jun 15, 2010 at 02:38:26PM +0200, Marek Szyprowski wrote:
> 
> > Are global exports preferred over the callbacks? I saw both in different
> > MFD drivers and was not sure which one to use.
> 
> > I've selected callbacks, because they are a bit nicer and don't pollute
> > the name space for each single driver. In my opinion the cost of these
> > 3 max8998_reg_{read,write,update} inline functions in regulator/max8998.c
> > is not so significant.
> 
> The dereferences looked fairly painful reading the code.  You can always
> do the global stuff as static inlines in the header file which avoids
> namespace pollution while keeping the code looking like a function call.

Ok, I will provide a patch that moves {read,write,update}_reg functions to
linux/mfs/max8998-private.h soon.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


