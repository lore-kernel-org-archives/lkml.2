Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1LCJDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 04:03:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50541 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab1LCJDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 04:03:11 -0500
Date: Sat, 3 Dec 2011 10:03:04 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: stable-3.1: iwlwifi broken with nomsi
Message-ID: <20111203090304.GA15498@localhost>
References: <20111128195939.GA15362@localhost>
 <20111202231858.GC6016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202231858.GC6016@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 03:18:58PM -0800, Greg KH wrote:
> On Mon, Nov 28, 2011 at 08:59:39PM +0100, Johan Hovold wrote:
> > Hi Greg, 
> > 
> > I believe commit 63665158282dd3b5d70 (iwlwifi: allow pci_enable_msi fail)
> > needs to be added to the 3.1 stable tree as the driver fails to probe
> > with MSI disabled since commit 084dd79172cb3 (iwlagn: move PCI related
> > operations from probe and remove to PCI layer) without it:
> 
> I do not see commit 63665158282dd3b5d70 in Linus's tree, did you get it
> incorrect?

Yes, that should have been 8a39ef8ba0fa0410d71db8e981e887fe4fdeca88 in
Linus' tree. 

Sorry about the confusion,
Johan
