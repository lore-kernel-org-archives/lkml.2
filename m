Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab2CAOMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:12:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53770 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616Ab2CAOML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:12:11 -0500
Date: Thu, 1 Mar 2012 14:11:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 1/4] x86: add NO_IRQ macro
Message-ID: <20120301141153.GH7363@n2100.arm.linux.org.uk>
References: <cover.1330607068.git.rubini@gnudd.com> <6bda7538144dce0bf5780df3d0601147dae753b5.1330607068.git.rubini@gnudd.com> <20120301140753.5c44e27e@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301140753.5c44e27e@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 02:07:53PM +0000, Alan Cox wrote:
> On Thu, 1 Mar 2012 14:28:36 +0100
> Alessandro Rubini <rubini@gnudd.com> wrote:
> 
> > This is needed to compile AMBA drivers. Most architectures define
> > NO_IRQ as -1, and this does the same for the PC.
> 
> NAK
> 
> "No IRQ" is 0. There are a few platforms which incorrectly still define it
> as -1 but they are broken and in fact many drivers won't work with
> platforms that still incorrectly use -1. Nothing should be using a
> NO_IRQ define.
> 
> Fix the users.

The users in this area are fixed and have been 'fixed' since December, it's
just going to take a couple of kernel cycles to get rid of it in a sane way
without causing breakage.  And yes, this has fallen squarely on my shoulders
to 'fix' because no one else is the least bit interested in the problem.

So, as I'm about the only one who has done any work towards this, you can
expect NO_IRQ to take a long time to finally go away.
