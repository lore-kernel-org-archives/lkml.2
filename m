Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab1FWRLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:11:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36598 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932535Ab1FWRLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:11:24 -0400
Date: Thu, 23 Jun 2011 13:11:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Mickler <florian@mickler.org>
cc: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: Oops in i915 intel_init_clock_gating
In-Reply-To: <20110623185212.4ec716b6@schatten.dmk.lab>
Message-ID: <Pine.LNX.4.44L0.1106231310590.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Florian Mickler wrote:

> On Wed, 22 Jun 2011 15:04:56 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Wed, 22 Jun 2011, Keith Packard wrote:
> > 
> > > On Wed, 15 Jun 2011 13:32:56 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > 
> > > I haven't seen any comments as to whether this patch needs to be merged
> > > into the kernel. Has anyone tested this?
> > 
> > I have tested it, and it worked well on my system:
> > 
> > 	http://marc.info/?l=linux-kernel&m=130817292323254&w=2
> > 
> > Alan Stern
> > 
> Some clock-gating patch was also proposed here:
> https://bugzilla.kernel.org/show_bug.cgi?id=37252

That was a different fix for a different problem, although the symptoms 
were the same.

Alan Stern

