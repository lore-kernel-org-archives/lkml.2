Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab0CVWSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:18:32 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:5772 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab0CVWSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:18:31 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Otavio Salvador <otavio@ossystems.com.br>
Subject: Re: PCI conflicts with latest kernels
Date: Mon, 22 Mar 2010 15:18:21 -0700
User-Agent: KMail/1.9.10
Cc: Giampaolo Bellini <iw2lsi@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <463bccef1003140331h72b1f11qe133a6a1c952fc6d@mail.gmail.com> <201003220850.39053.bjorn.helgaas@hp.com> <be7a9f3d1003221427l484014faq188552d6fce59e9f@mail.gmail.com>
In-Reply-To: <be7a9f3d1003221427l484014faq188552d6fce59e9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003221618.24217.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010 03:27:18 pm Otavio Salvador wrote:
> Hello Bjorn,
> 
> On Mon, Mar 22, 2010 at 11:50 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Monday 22 March 2010 08:41:03 am Otavio Salvador wrote:
> >> I have this same problem in VortexSX machine.
> > Can you post your entire dmesg log and a description of what
> > problem you're seeing (e.g., device X doesn't work or whatever)?
> > If this is a regression, i.e., your system used to work and
> > now doesn't work, please tell us which version used to work
> > and when it broke.

Since you don't mention any working version, I assume that Linux
has never worked correctly on this system.

> This has already been done at http://article.gmane.org/gmane.linux.kernel/916237

That post is about the fact that your disk doesn't work unless you
use "irqpoll".  That just means the interrupts don't appear where
we expect them, which has nothing to do with the PCI address space
collisions.

I'm sorry I don't know enough about interrupts to help more.  If
I were debugging it, I would start by adding printks to the
pirq_enable_irq() path and see if I could figure out why it works
for some devices, but for IDE.

Bjorn
