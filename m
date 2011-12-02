Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1LBXmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:42:39 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33834 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab1LBXmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:42:37 -0500
X-Sasl-enc: MDFMiLo/B16IUQIMZY0sYf56ZYAZVvWvH6hFpHvdrVyu 1322869356
Date: Fri, 2 Dec 2011 15:42:30 -0800
From: Greg KH <greg@kroah.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: stable-3.1: iwlwifi broken with nomsi
Message-ID: <20111202234230.GA3671@kroah.com>
References: <20111128195939.GA15362@localhost>
 <20111202231858.GC6016@kroah.com>
 <1322864922.13074.27.camel@wwguy-huron>
 <20111202233256.GA605@kroah.com>
 <1322865584.13074.29.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322865584.13074.29.camel@wwguy-huron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 02:39:44PM -0800, Guy, Wey-Yi wrote:
> Hi Greg,
> 
> On Fri, 2011-12-02 at 15:32 -0800, Greg KH wrote:
> > On Fri, Dec 02, 2011 at 02:28:42PM -0800, Guy, Wey-Yi wrote:
> > > On Fri, 2011-12-02 at 15:18 -0800, Greg KH wrote:
> > > > On Mon, Nov 28, 2011 at 08:59:39PM +0100, Johan Hovold wrote:
> > > > > Hi Greg, 
> > > > > 
> > > > > I believe commit 63665158282dd3b5d70 (iwlwifi: allow pci_enable_msi fail)
> > > > > needs to be added to the 3.1 stable tree as the driver fails to probe
> > > > > with MSI disabled since commit 084dd79172cb3 (iwlagn: move PCI related
> > > > > operations from probe and remove to PCI layer) without it:
> > > > 
> > > > I do not see commit 63665158282dd3b5d70 in Linus's tree, did you get it
> > > > incorrect?
> > > > 
> > > > confused,
> > > > 
> > > it is commit#8a39ef8ba0fa0410d71db8e981e887fe4fdeca88 in Linville's
> > > wireless tree
> > 
> > How nice, and what exactly can I do with that at this point in time?
> > 
> Can I send the patch to you for stable 3.1?

Again:

> > Come on, please go read Documentation/stable_kernel_rules.txt again for
> > how to do this properly...

Please read that and see _HOW_ to do this, and what the requirements are.

greg k-h
