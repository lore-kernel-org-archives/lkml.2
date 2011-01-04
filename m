Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1ADR0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:26:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47046
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388Ab1ADR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:26:06 -0500
Date: Tue, 04 Jan 2011 09:26:37 -0800 (PST)
Message-Id: <20110104.092637.226761806.davem@davemloft.net>
To: alex.buell@munted.org.uk
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Using s3virge card in Sun Blade 2000
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294156627.17576.21.camel@lithium>
References: <1294090573.17576.16.camel@lithium>
	<20110103.143625.193710368.davem@davemloft.net>
	<1294156627.17576.21.camel@lithium>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Buell <alex.buell@munted.org.uk>
Date: Tue, 04 Jan 2011 15:57:07 +0000

> On Mon, 2011-01-03 at 14:36 -0800, David Miller wrote:
>> From: Alex Buell <alex.buell@munted.org.uk>
>> Date: Mon, 03 Jan 2011 21:36:13 +0000
>> 
>> > Those are 32 bit addresses, so I suppose I should be getting the base
>> > address for the registers accesses from region 1, right? 
>> 
>> Yes, and pre-computed addresses exist in pci_region_start(pdev, 1).
> 
> Do you have any tips for reducing the amount of reboots I have to do
> whenever I try loading the s3fb module after changing code? 

You should build s3fb as a module, block it from auto-loading in
/etc/modules.conf, and then load it explicitly by hand as you
make changes and recompile.
