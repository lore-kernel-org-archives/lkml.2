Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab1CRRl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:41:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45213 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab1CRRlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:41:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI/ACPI: Report ASPM support to BIOS if not disabled from command line
Date: Fri, 18 Mar 2011 18:41:28 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-pci@vger.kernel.org
References: <201103051321.51856.rjw@sisk.pl> <20110318012556.GA13851@srcf.ucam.org> <20110317214152.503adac8@jbarnes-x200>
In-Reply-To: <20110317214152.503adac8@jbarnes-x200>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103181841.28636.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 18, 2011, Jesse Barnes wrote:
> On Fri, 18 Mar 2011 01:25:56 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > On Fri, Mar 18, 2011 at 10:10:20AM +0900, Kenji Kaneshige wrote:
> > > Jesse,
> > >
> > > This patch fixes the problem that PCIe hotplug no longer work in
> > > 2.6.38 on my platform (ASPM is disabled　through ACPI FADT in my
> > > platform). I think this need to be applied soon.
> > >
> > > Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > > Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > 
> > Yes, I think we need to look at -stable for this one.
> 
> Ok, thanks guys.  I'll queue it up in -fixes and send it to Linus after
> my 2.6.39 pull req with a cc for stable.

Well, I thought you could simply include it into the pull request. :-)

Thanks,
Rafael
