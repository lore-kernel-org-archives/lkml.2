Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab2FDKWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:22:11 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:54379 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823Ab2FDKWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:22:10 -0400
Date: Mon, 4 Jun 2012 12:21:41 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: benh@kernel.crashing.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        sameo@linux.intel.com, x86@kernel.org, lenb@kernel.org
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
Message-ID: <20120604102141.GA7967@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1338804972.7150.77.camel@pasglop>
References: <1338804972.7150.77.camel@pasglop>
  <4FC477A1.4010709@zytor.com>  <4FC47003.1080906@zytor.com>
  <4FC40C74.8050003@zytor.com>  <20120527205020.GA3050@mail.gnudd.com>
  <20120529063738.GA22711@mail.gnudd.com>
  <20120529070557.GA23373@mail.gnudd.com>
  <20120529073417.GA25041@mail.gnudd.com> <4FC47D49.50204@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, a device-tree blob could easily be passed an x86 has the
> infrastructure to use it already afaik.

Yes, that's the direction I'm aiming at.  I hope it's possibly to also
load a device sub-tree later (which is needed when the pci device is
a plug-in board instead of the main chipset in the motherboard.

> That or the ACPI way but I know nothing about it and thus naturally
> assume it's harder :-)

I'm studying this first, hoping to confirm my bad feeling about it and
be happier when working with fdt. Also, I'd better remain portable, in
case vendors will package the sta2x11 as a pci board -- the one I have is
just the development system and it's not largely marketed.

Thanks
/alessandro
