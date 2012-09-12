Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314Ab2ILQOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:14:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47060 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759809Ab2ILQOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:14:14 -0400
X-Sasl-enc: lQ6xy7zkYbBMX7hgN5O/0lul3SYuimwLiOLAxVCKVplx 1347466453
Date: Wed, 12 Sep 2012 09:14:12 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20120912161412.GE7273@kroah.com>
References: <20120912153756.1483e19457d053914f82ce28@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912153756.1483e19457d053914f82ce28@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 03:37:56PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/dwc3/gadget.c between commit f4a53c55117b ("usb: dwc3:
> gadget: fix pending isoc handling") from the usb.current tree and commit
> 348e026fafe2 ("usb: dwc3: gadget: Fix sparse warnings") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks for the warning, I'll resolve this when Linus pulls from this
tree later this week.

greg k-h
