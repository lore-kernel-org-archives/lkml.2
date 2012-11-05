Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2KEKcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:32:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab2KEKcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:32:01 -0500
Date: Mon, 5 Nov 2012 11:31:44 +0100
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Subject: Re: [PATCHv8 0/3]virtio_console: Add rproc_serial driver
Message-ID: <20121105103144.GB12402@amit.redhat.com>
References: <1351587113-2566-1-git-send-email-sjur@brendeland.net>
 <877gq1yora.fsf@rustcorp.com.au>
 <20121105103124.GA12402@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121105103124.GA12402@amit.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 05 Nov 2012 [11:31:24], Amit Shah wrote:
> On (Mon) 05 Nov 2012 [09:11:45], Rusty Russell wrote:
> > Sjur Brændeland <sjur@brendeland.net> writes:
> > 
> > > From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> > >
> > > This patch-set introduces a new virtio type "rproc_serial" for communicating
> > > with remote processors over shared memory. The driver depends on the
> > > the remoteproc framework. As preparation for introducing "rproc_serial"
> > > I've done a refactoring of the transmit buffer handling.
> > >
> > > Changes since v7:
> > > - Rebased to virtio-next branch.
> > > - Removed extra added lines.
> > > - Removed superfluous checks before calling reclaim_dma_bufs().
> > > - Rusty raised some question regarding garbage collection of the
> > >   out-vq, so I moved this into a separate patch.
> > 
> > OK, I'm not sure that WARN_ON won't fire, but that's not all that
> > harmful.
> 
> Sjur said he'll send out a respin for this; can you wait for his v8?

Er, v9.

		Amit
