Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1ACWf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 17:35:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42957
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752Ab1ACWfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 17:35:55 -0500
Date: Mon, 03 Jan 2011 14:36:25 -0800 (PST)
Message-Id: <20110103.143625.193710368.davem@davemloft.net>
To: alex.buell@munted.org.uk
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Using s3virge card in Sun Blade 2000
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294090573.17576.16.camel@lithium>
References: <1294086801.17576.14.camel@lithium>
	<20110103.123939.02282416.davem@davemloft.net>
	<1294090573.17576.16.camel@lithium>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Buell <alex.buell@munted.org.uk>
Date: Mon, 03 Jan 2011 21:36:13 +0000

> Those are 32 bit addresses, so I suppose I should be getting the base
> address for the registers accesses from region 1, right? 

Yes, and pre-computed addresses exist in pci_region_start(pdev, 1).
