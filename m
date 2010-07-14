Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0GNP1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:27:00 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:34137 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754579Ab0GNP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:26:58 -0400
Date: Wed, 14 Jul 2010 11:26:38 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pedro Ribeiro <pedrib@gmail.com>, eusou15@yahoo.com,
        ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        toralf.foerster@gmx.de
Subject: Re: [PATCH] Remove 9 second reboot delay on Lenovo T400/T500
Message-ID: <20100714152638.GA28513@elliptictech.com>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Pedro Ribeiro <pedrib@gmail.com>, eusou15@yahoo.com,
	ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	toralf.foerster@gmx.de
References: <4C3DCAA4.9050602@gmail.com>
 <20100714143625.GA30721@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714143625.GA30721@srcf.ucam.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:36 Wed 14 Jul     , Matthew Garrett wrote:
> On Wed, Jul 14, 2010 at 03:33:08PM +0100, Pedro Ribeiro wrote:
> >  The Lenovo T400 and T500 have an annoying 9 second delay when
> >  rebooting, unless reboot=pci is passed to the kernel command line.
> >  This delay happens from at least kernel 2.6.20.
[...]
> 1) Lenovo's firmware is broken and the 9-second delay is always going to 
> be there. In that case we should try to use the ACPI reboot vector 
> first.

While it may be true that the firmware is buggy, reboot=acpi does not
solve the problem; reboot=pci does.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
