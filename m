Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2KTMgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:36:39 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:25810 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2KTMgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:36:36 -0500
Message-ID: <1353414988.4414.42.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] PCI: MSI: Restore read_msi_msg_desc(); add
 get_cached_msi_msg_desc()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 20 Nov 2012 12:36:28 +0000
In-Reply-To: <1353396032.17856.7.camel@pasglop>
References: <20100723102202.871a3131.sfr@canb.auug.org.au>
	 <1279847985.4883.391.camel@localhost> <1279850740.6381.19.camel@concordia>
	 <1279893388.2089.9.camel@achroite.uk.solarflarecom.com>
	 <1353396032.17856.7.camel@pasglop>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 18:20 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2010-07-23 at 14:56 +0100, Ben Hutchings wrote:
> > commit 2ca1af9aa3285c6a5f103ed31ad09f7399fc65d7 "PCI: MSI: Remove
> > unsafe and unnecessary hardware access" changed read_msi_msg_desc() to
> > return the last MSI message written instead of reading it from the
> > device, since it may be called while the device is in a reduced
> > power state.
> 
> Looks reasonable... Jesse ?
[...]

So reasonable that it was committed a couple of years ago!

Where did you dredge this from?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

