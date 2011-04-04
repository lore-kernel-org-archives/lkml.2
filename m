Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1DDVVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:21:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:46920 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab1DDVVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:21:06 -0400
Subject: Re: [RFC/PATCH] of: Match PCI devices to OF nodes generically
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <BANLkTimBD=NfFKGpy0ZTnT9Dcu=dkTHxZg@mail.gmail.com>
References: <1301882694.2549.53.camel@pasglop>
	 <1301887630.2549.71.camel@pasglop> <1301902664.2549.76.camel@pasglop>
	 <BANLkTimBD=NfFKGpy0ZTnT9Dcu=dkTHxZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 07:03:57 +1000
Message-ID: <1301951037.2549.85.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 09:25 -0600, Bjorn Helgaas wrote:
> 
> Some of this is reminiscent of the ACPI/PCI binding we do on x86/ia64,
> e.g., acpi_get_pci_dev() and the stuff in drivers/acpi/glue.c.  Have
> you looked at that to see if there's any hope of covering both OF and
> ACPI with something more generic?

I haven't but I will have a look. Thanks.

Cheers,
Ben.


