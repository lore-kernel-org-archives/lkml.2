Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0KZPLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:11:38 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36476 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0KZPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:11:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JR0WMYrpRshgYtVH4bI1/59MpCWfb9jX4gU6y9I352VLHgRDHOOilTkmRoMQhvYt4G
         PUy4dq4dZLvLj8L8NQio7eKnLgg6swoHCJKfzfdGk0K4i5hwcTeFfMWmR9hSrP/keI8I
         8us4F7uxXW7KaZRbmY5EeBABjuUHoFSAQ7LBc=
Date: Fri, 26 Nov 2010 18:11:31 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
Cc: mkl0301@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/1] USB: cns3xxx: Add EHCI and OHCI bus glue for
 cns3xxx SOCs
Message-ID: <20101126151131.GA26602@oksana.dev.rtsoft.ru>
References: <20101125171541.GA18152@suse.de>
 <Pine.LNX.4.44L0.1011251521310.26094-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1011251521310.26094-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 03:22:06PM -0500, Alan Stern wrote:
[...]
> > > > From: Mac Lin <mkl0301@gmail.com>
> > > > 
> > > > The CNS3XXX SOC has include USB EHCI and OHCI compatible controllers. This
> > > > patch adds the necessary glue logic to allow ehci-hcd and ohci-hcd drivers to
> > > > work on CNS3XXX
> > > > 
> > > > The EHCI and OHCI controllers share a common clock control and reset bit,
> > > > therefore additional check for the timming of enabling and disabling is
> > > > required. The USB bit of PLL Power Down Control is also shared by OTG, 24MHz
> > > > UART clock, Crypto clock, PCIe reference clock, and Clock Scale Generator.
> > > > Therefore we only ensure it is enabled, while not disabling it.
> > > > 
> > > > Signed-off-by: Mac Lin <mkl0301@gmail.com>
> > > 
> > > Thanks for the patch!
> > > 
> > > Cc'ing Greg.
> > > 
> > > Greg, the patch doesn't touch any sensitive parts of EHCI and OHCI
> > > drivers, can I take it via ARM subtree? This is to not introduce
> > > cross-tree dependencies (the patch depends on some arch-specific
> > > changes).
> > 
> > Please get Alan Stern to ack it as well, as he knows the proper
> > callbacks that you need to ensure are present.
> 
> As far as the callbacks are concerned, this looks fine.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks Alan!

Greg, should I treat your 'to ack it as well' as 'Acked-by'? :-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
