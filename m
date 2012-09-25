Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2IYWjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:39:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47191 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836Ab2IYWjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:39:23 -0400
X-Sasl-enc: YF/nAIcjHytTPUs+TtLQHZ73+tHhXqHbOvDtY3l7nP9c 1348612762
Date: Tue, 25 Sep 2012 15:39:21 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>, Len Brown <lenb@kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: linux-next: manual merge of the usb tree with the acpi tree
Message-ID: <20120925223921.GB6282@kroah.com>
References: <20120924164916.faeb0225ef2b0732762d8aac@canb.auug.org.au>
 <20120924165449.58e81fb0c925ecc580ec502e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924165449.58e81fb0c925ecc580ec502e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 04:54:49PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 24 Sep 2012 16:49:16 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/usb/core/usb-acpi.c between commit 59e6423ba8aa ("usb-acpi:
> > Comply with the ACPI API change") from the acpi tree and commit
> > 05f916894a69 ("usb/acpi: Store info on device removability") from the usb
> > tree.
> > 
> > The latter removed the function changed by the former, so I just did that
> > and can carry the fix as necessary (no action is required).
> 
> It also needed this merge fix patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 24 Sep 2012 16:51:38 +1000
> Subject: [PATCH] usb-acpi: Comply with the ACPI API change after usb tree
>  merge
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/usb/core/usb-acpi.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Ick, thanks for this, hopefully Len handles this properly during the
merge window :)

greg k-h
