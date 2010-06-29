Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0F2XgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 19:36:25 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:50566 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0F2XgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 19:36:24 -0400
Date: Tue, 29 Jun 2010 19:36:18 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building
 code  out into drivers/of
Message-ID: <20100629193618.5a840b8e@dev.queued.net>
In-Reply-To: <AANLkTinPsrqxj5oQirEDRvVOuOeWgWSdljsMRbw8wn8V@mail.gmail.com>
References: <20100628215407.2017bf2f@debian>
	<20100628220037.5744c207@debian>
	<AANLkTilN3_ntG7AWKi-8LM9X_dZJPPlWM6xRM_V_00xU@mail.gmail.com>
	<20100629110324.2756cc02@debian>
	<AANLkTinPsrqxj5oQirEDRvVOuOeWgWSdljsMRbw8wn8V@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 15:42:54 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Tue, Jun 29, 2010 at 9:03 AM, Andres Salomon <dilinger@queued.net>
> wrote:
[...]
> 
> >  Sparc and OLPC have very similar
> > mechanisms for getting device tree info from OFW, so it makes sense
> > to share code between them.
> 
> Other than the flattened tree step; is the powerpc method dissimilar
> from the Sparc and OLPC method for talking to OFW?  (This is not a
> rhetorical question, I'm want to know if I'm missing some details).
> The main difference I know about is that OFW can still kept alive at
> runtime for sparc, which powerpc does not do.  However, keeping OFW
> callable is a separate issue from how to extract the device tree.
> 

After having a look at powerpc's flatten_device_tree, I don't see any
obvious reason why OLPC couldn't use this (though it still strikes me
as weird to go from prom->fdt->dt when the option of prom->dt is
available and less complex). Do you already have the patches that put
this into drivers/of/?
