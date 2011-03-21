Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1CUQiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:38:06 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:33110 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753675Ab1CUQiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:38:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sBudN7vSV74Diu7c7xvXjUN8ogdjAFgZkhRWlOGWAT9BiaL/0+Z213CYYXh+bnG4sJ/7H58v5UcImRwURw6sUvJvBOG6vK8bcXQG+rwBbsvFK8HocrK+agcbnLvvHU0c;
Date: Mon, 21 Mar 2011 09:37:58 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI/ACPI: Report ASPM support to BIOS if not disabled
 from command line
Message-ID: <20110321093758.0c029496@jbarnes-desktop>
In-Reply-To: <201103181841.28636.rjw@sisk.pl>
References: <201103051321.51856.rjw@sisk.pl>
	<20110318012556.GA13851@srcf.ucam.org>
	<20110317214152.503adac8@jbarnes-x200>
	<201103181841.28636.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 18:41:28 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Friday, March 18, 2011, Jesse Barnes wrote:
> > On Fri, 18 Mar 2011 01:25:56 +0000
> > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > 
> > > On Fri, Mar 18, 2011 at 10:10:20AM +0900, Kenji Kaneshige wrote:
> > > > Jesse,
> > > >
> > > > This patch fixes the problem that PCIe hotplug no longer work in
> > > > 2.6.38 on my platform (ASPM is disabled　through ACPI FADT in my
> > > > platform). I think this need to be applied soon.
> > > >
> > > > Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > > > Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > > 
> > > Yes, I think we need to look at -stable for this one.
> > 
> > Ok, thanks guys.  I'll queue it up in -fixes and send it to Linus after
> > my 2.6.39 pull req with a cc for stable.
> 
> Well, I thought you could simply include it into the pull request. :-)

Applied, I'll send it to Linus this week.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
