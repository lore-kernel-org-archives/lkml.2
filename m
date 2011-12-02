Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1LBXhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:37:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:25949 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab1LBXhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:37:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,286,1320652800"; 
   d="scan'208";a="91756844"
Subject: Re: stable-3.1: iwlwifi broken with nomsi
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
In-Reply-To: <20111202233256.GA605@kroah.com>
References: <20111128195939.GA15362@localhost>
	 <20111202231858.GC6016@kroah.com> <1322864922.13074.27.camel@wwguy-huron>
	 <20111202233256.GA605@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 14:39:44 -0800
Message-ID: <1322865584.13074.29.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, 2011-12-02 at 15:32 -0800, Greg KH wrote:
> On Fri, Dec 02, 2011 at 02:28:42PM -0800, Guy, Wey-Yi wrote:
> > On Fri, 2011-12-02 at 15:18 -0800, Greg KH wrote:
> > > On Mon, Nov 28, 2011 at 08:59:39PM +0100, Johan Hovold wrote:
> > > > Hi Greg, 
> > > > 
> > > > I believe commit 63665158282dd3b5d70 (iwlwifi: allow pci_enable_msi fail)
> > > > needs to be added to the 3.1 stable tree as the driver fails to probe
> > > > with MSI disabled since commit 084dd79172cb3 (iwlagn: move PCI related
> > > > operations from probe and remove to PCI layer) without it:
> > > 
> > > I do not see commit 63665158282dd3b5d70 in Linus's tree, did you get it
> > > incorrect?
> > > 
> > > confused,
> > > 
> > it is commit#8a39ef8ba0fa0410d71db8e981e887fe4fdeca88 in Linville's
> > wireless tree
> 
> How nice, and what exactly can I do with that at this point in time?
> 
Can I send the patch to you for stable 3.1?

> 
> Come on, please go read Documentation/stable_kernel_rules.txt again for
> how to do this properly...
> 

Sorry, my mistake and did not realize the offending patch is in 3.1
already.

Wey




