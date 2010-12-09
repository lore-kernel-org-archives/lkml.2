Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0LIQyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:54:40 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:44898 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0LIQyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:54:38 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86/PCI: never allocate PCI space from the last 1M below 4G
Date: Thu, 9 Dec 2010 09:54:24 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Matthew Garrett <mjg@redhat.com>, Yinghai Lu <yinghai@kernel.org>
References: <20101129183009.11256.33739.stgit@bob.kio> <AANLkTinJhVj7sY6wC1tFRA+rYW72j7GqKvxfRsyRC=Vs@mail.gmail.com> <201012030815.52203.bjorn.helgaas@hp.com>
In-Reply-To: <201012030815.52203.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012090954.24538.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010 08:15:48 am Bjorn Helgaas wrote:
> On Thursday, December 02, 2010 06:19:20 pm Linus Torvalds wrote:
> > On Mon, Nov 29, 2010 at 2:04 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > >
> > > I think we're talking about whether to reserve the top 1MB or top 2MB.
> > > I freely admit I don't know the right answer.  My point is merely that
> > > since we're using a heuristic anyway, copying Windows is a pretty good
> > > starting point.  In my mind, doing something different requires a
> > > stronger argument than "it might fix some machines where Windows is
> > > broken."
> > 
> > What's the status of this? The original patch is pretty nasty, and I
> > think that hack to put things in the bios_align_resource() function is
> > just disgusting.

OK, let's drop this approach.  My next proposal is the
"PCI, PNP, resources: effectively reserve ACPI device resources"
thread I posted yesterday (with mangled cover letter) here:

    https://lkml.org/lkml/2010/12/8/352

Bjorn
