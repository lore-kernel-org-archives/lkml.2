Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab2FZDgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:36:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57659 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab2FZDgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:36:52 -0400
Date: Mon, 25 Jun 2012 20:36:47 -0700 (PDT)
Message-Id: <20120625.203647.858968941068541020.davem@davemloft.net>
To: myron.stowe@redhat.com
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@arm.linux.org.uk,
        starvik@axis.com, jesper.nilsson@axis.com, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, chris@zankel.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/16] sparc/PCI: Factor 'pcibios_setup()' out of sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120626033212.16434.95081.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
	<20120626033212.16434.95081.stgit@amt.stowe>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <myron.stowe@redhat.com>
Date: Mon, 25 Jun 2012 21:32:12 -0600

> The PCI core provides a generic (__weak) 'pcibios_setup()' routine
> that can be used by all architectures as a default.  Drop sparc's
> architecture specific version in favor of that as it does not need to be
> over-ridden.
> 
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
