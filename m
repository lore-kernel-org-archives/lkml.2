Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab0FHIBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:01:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42626 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751479Ab0FHIBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:01:47 -0400
Date: Tue, 8 Jun 2010 09:10:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
Message-ID: <20100608091012.034f1cca@lxorguk.ukuu.org.uk>
In-Reply-To: <4C0D8F43.4070900@zytor.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<4C0D8F43.4070900@zytor.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You may not use a 1-1 mapping if you don't have legacy irqs.  Linux
> > irqs 0-15 are the ISA irqs you may not use those irq numbers for

Linux IRQ 0 is "no IRQ assigned", except buried in certain bits of arch
specific historical knowledge.

Also calling 1-15 ISA IRQ lines is also somewhat misleading given they
are almost certainly routing for PCI devices. "PIC IRQ routing" maybe -
but even that is not really true on a lot of PC hardware today except by
convention.
