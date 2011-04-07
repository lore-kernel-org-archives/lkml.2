Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab1DGEUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 00:20:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:38808 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1DGEUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 00:20:41 -0400
Subject: Re: [PATCH 1/5] pci/of: Match PCI devices to OF nodes dynamically
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
	 <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 14:20:19 +1000
Message-ID: <1302150019.2458.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 13:26 +1000, Benjamin Herrenschmidt wrote:
> powerpc has two different ways of matching PCI devices to their
> corresponding OF node (if any) for historical reasons. The ppc64 one
> does a scan looking for matching bus/dev/fn, while the ppc32 one does a
> scan looking only for matching dev/fn on each level in order to be
> agnostic to busses being renumbered (which Linux does on some
> platforms).

Crap ! I got the Linutronix guys email wrong oops ... If you reply,
please beware of the CC list, s/linuxtronix.de/linutronix.de.

Thomas, Sebastian, I suppose I don't need to re-send a private copy, you
should be able to find the patches ? :-)

Cheers,
Ben.


