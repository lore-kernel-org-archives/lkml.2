Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2FZFxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:53:34 -0400
Received: from linux-sh.org ([111.68.239.195]:51906 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744Ab2FZFxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:53:31 -0400
Date: Tue, 26 Jun 2012 14:51:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@arm.linux.org.uk,
        starvik@axis.com, jesper.nilsson@axis.com, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, chris@zankel.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/16] sh/PCI: Factor 'pcibios_setup()' out of sh
Message-ID: <20120626055129.GF24033@linux-sh.org>
References: <20120626033045.16434.17412.stgit@amt.stowe>
 <20120626033158.16434.94698.stgit@amt.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626033158.16434.94698.stgit@amt.stowe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 09:31:58PM -0600, Myron Stowe wrote:
> The PCI core provides a generic (__weak) 'pcibios_setup()' routine that can
> be used by all architectures as a default.  Drop sh's architecture specific
> version in favor of that as it does not need to be over-ridden.
> 
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
