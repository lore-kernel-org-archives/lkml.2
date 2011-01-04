Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab1ADP6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:58:41 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:39083
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357Ab1ADP6k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:58:40 -0500
Subject: Re: Using s3virge card in Sun Blade 2000
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: David Miller <davem@davemloft.net>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110103.143625.193710368.davem@davemloft.net>
References: <1294086801.17576.14.camel@lithium>
	 <20110103.123939.02282416.davem@davemloft.net>
	 <1294090573.17576.16.camel@lithium>
	 <20110103.143625.193710368.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Tue, 04 Jan 2011 15:57:07 +0000
Message-ID: <1294156627.17576.21.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4d2343ac.12c6-25a-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 14:36 -0800, David Miller wrote:
> From: Alex Buell <alex.buell@munted.org.uk>
> Date: Mon, 03 Jan 2011 21:36:13 +0000
> 
> > Those are 32 bit addresses, so I suppose I should be getting the base
> > address for the registers accesses from region 1, right? 
> 
> Yes, and pre-computed addresses exist in pci_region_start(pdev, 1).

Do you have any tips for reducing the amount of reboots I have to do
whenever I try loading the s3fb module after changing code? 
-- 
Tactical Nuclear Kittens
