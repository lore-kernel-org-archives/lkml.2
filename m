Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738Ab1FWQwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:52:23 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51436 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759069Ab1FWQwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:52:22 -0400
Date: Thu, 23 Jun 2011 18:52:12 +0200
From: Florian Mickler <florian@mickler.org>
To: Keith Packard <keithp@keithp.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: Oops in i915 intel_init_clock_gating
Message-ID: <20110623185212.4ec716b6@schatten.dmk.lab>
In-Reply-To: <Pine.LNX.4.44L0.1106221504070.1977-100000@iolanthe.rowland.org>
References: <yun4o3h68gs.fsf@aiko.keithp.com>
	<Pine.LNX.4.44L0.1106221504070.1977-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 15:04:56 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 22 Jun 2011, Keith Packard wrote:
> 
> > On Wed, 15 Jun 2011 13:32:56 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > I haven't seen any comments as to whether this patch needs to be merged
> > into the kernel. Has anyone tested this?
> 
> I have tested it, and it worked well on my system:
> 
> 	http://marc.info/?l=linux-kernel&m=130817292323254&w=2
> 
> Alan Stern
> 
Some clock-gating patch was also proposed here:
https://bugzilla.kernel.org/show_bug.cgi?id=37252

Regards,
Flo
