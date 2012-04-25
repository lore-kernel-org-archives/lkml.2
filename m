Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2DYQqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:46:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36566 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab2DYQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:45:57 -0400
Date: Wed, 25 Apr 2012 17:45:48 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for Apr 17 (pci-sysfs.c and vga_switcheroo.c)
Message-ID: <20120425164548.GB17905@srcf.ucam.org>
References: <20120417144241.0d7dc5fde56b2a37ff0dcaba@canb.auug.org.au>
 <4F8DB90A.8050504@xenotime.net>
 <CAErSpo56ddRZCG=5yqcEUBPZ1_x76=33xkv5x-46gcNgQCA0Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo56ddRZCG=5yqcEUBPZ1_x76=33xkv5x-46gcNgQCA0Qg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:37:26AM -0600, Bjorn Helgaas wrote:
> I assume this is related to 77b267c7549e3629ea55cf780aa3d474da7bc2d5
> ("vgaarb: Add support for setting the default video device") and that
> Matthew will take care of whatever needs to be done (if it's not fixed
> already).

Dave has patches.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
