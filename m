Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0IJExg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 00:53:36 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:25603 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794Ab0IJExc (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:2>);
	Fri, 10 Sep 2010 00:53:32 -0400
Message-Id: <4C8A4668020000230002021A@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 09 Sep 2010 22:53:28 -0600
From: "Joey Lee" <jlee@novell.com>
To: <gregkh@suse.de>
Cc: <mjg@redhat.com>, <mjg59@srcf.ucam.org>, <trenn@suse.de>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add Intel Poulsbo Stub Driver
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, 

於 三，2010-09-01 於 08:00 -0700，Greg KH 提到：
> On Wed, Sep 01, 2010 at 05:08:39PM +0800, Lee, Chun-Yi wrote:
> > +static struct pci_device_id pciidlist[] = {
> > +	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108}, \
> > +	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109}, \
> > +	{0, 0, 0}
> > +};
> 
> Now that you have this, just use:
> 	MODULE_DEVICE_TABLE(pci, pciidlist);
> instead of:
> 
> > +MODULE_ALIAS("pci:v00008086d00008108sv*sd*bc*sc*i*");
> > +MODULE_ALIAS("pci:v00008086d00008109sv*sd*bc*sc*i*");
> 
> As the proper alias will automatically get generated from the
> MODULE_DEVICE_TABLE() macro.
> 

Thank's for your review and kindly suggestion.
It's useful to me! :-)

And it works fine on my Poulsbo machine, I will use:
	MODULE_DEVICE_TABLE(pci, pciidlist);


Thank's a lot!
Joey Lee

