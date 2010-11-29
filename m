Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0K2Ngz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:36:55 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40912 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab0K2Ngx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:36:53 -0500
Date: Mon, 29 Nov 2010 05:36:42 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dsd@laptop.org, cjb@laptop.org
Subject: Re: [PATCH 2/4] cs5535-gpio: convert from pci device to platform
 device
Message-ID: <20101129053642.3f302e2b@debxo>
In-Reply-To: <20101129104812.GA2332@sortiz-mobl>
References: <20101023004109.319bbdef@queued.net>
	<20101126204426.162ebc75@debxo>
	<20101129104812.GA2332@sortiz-mobl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 11:48:13 +0100
Samuel Ortiz <sameo@linux.intel.com> wrote:

> Hi Andres,
> 
> On Fri, Nov 26, 2010 at 08:44:26PM -0800, Andres Salomon wrote:
> > Samuel, thanks for applying the mfd patch.  I'm not sure how the
> > rest of these should be handled; they depend upon the first patch.
> > Would you prefer they go through the mfd tree, or go in via
> > Andrew's tree?
> I typically take them, unless the corresponding subsystem maintainers
> disagree with it. I also really much prefer to get an ACK from them
> before taking the patches.
> 

Ok.  In this case, there are no subsystem maintainers for patches #2
and #3 (GPIO and misc), so there's no one to really get an ACK from.
I'm also the author for both of the modules.
