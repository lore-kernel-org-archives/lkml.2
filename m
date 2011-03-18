Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1CREmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:42:13 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58785 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753074Ab1CREmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:42:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rAkkli/RN59wCvS2F6+kmGmhCySyvJWsTV44QK3OFfpQViVbP6J6s+cvDCtHKb5a5V+0ia/XKFBJvVPVa2l4HJ6ALcxYCa/ru6yeQtrV+JjQLypaTl1lP8i0bG8hc0ym;
Date: Thu, 17 Mar 2011 21:41:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI/ACPI: Report ASPM support to BIOS if not disabled
 from command line
Message-ID: <20110317214152.503adac8@jbarnes-x200>
In-Reply-To: <20110318012556.GA13851@srcf.ucam.org>
References: <201103051321.51856.rjw@sisk.pl>
	<4D82B0FC.1060303@jp.fujitsu.com>
	<20110318012556.GA13851@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 01:25:56 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, Mar 18, 2011 at 10:10:20AM +0900, Kenji Kaneshige wrote:
> > Jesse,
> >
> > This patch fixes the problem that PCIe hotplug no longer work in
> > 2.6.38 on my platform (ASPM is disabled　through ACPI FADT in my
> > platform). I think this need to be applied soon.
> >
> > Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> Yes, I think we need to look at -stable for this one.

Ok, thanks guys.  I'll queue it up in -fixes and send it to Linus after
my 2.6.39 pull req with a cc for stable.

Jesse
