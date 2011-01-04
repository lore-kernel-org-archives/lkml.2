Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab1ADUMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:12:51 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:46020
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840Ab1ADUMu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:12:50 -0500
Subject: Re: Using s3virge card in Sun Blade 2000
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: David Miller <davem@davemloft.net>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110104.092637.226761806.davem@davemloft.net>
References: <1294090573.17576.16.camel@lithium>
	 <20110103.143625.193710368.davem@davemloft.net>
	 <1294156627.17576.21.camel@lithium>
	 <20110104.092637.226761806.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Tue, 04 Jan 2011 20:11:17 +0000
Message-ID: <1294171877.17576.24.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4d237f40.865a-6a9c-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 09:26 -0800, David Miller wrote:
> From: Alex Buell <alex.buell@munted.org.uk>
> Date: Tue, 04 Jan 2011 15:57:07 +0000
> 
> > On Mon, 2011-01-03 at 14:36 -0800, David Miller wrote:
> >> From: Alex Buell <alex.buell@munted.org.uk>
> >> Date: Mon, 03 Jan 2011 21:36:13 +0000
> >> 
> >> > Those are 32 bit addresses, so I suppose I should be getting the base
> >> > address for the registers accesses from region 1, right? 
> >> 
> >> Yes, and pre-computed addresses exist in pci_region_start(pdev, 1).
> > 
> > Do you have any tips for reducing the amount of reboots I have to do
> > whenever I try loading the s3fb module after changing code? 
> 
> You should build s3fb as a module, block it from auto-loading in
> /etc/modules.conf, and then load it explicitly by hand as you
> make changes and recompile.

I'm already doing that. In the instances where it results in a crash and
reboots are impossible, dropping into the OpenPROM results in a total
system freeze, cannot type anything in, this means a big red switch
time. Solaris didn't have this problem. Any ideas why Linux does this to
the OpenPROM? 
-- 
Tactical Nuclear Kittens
