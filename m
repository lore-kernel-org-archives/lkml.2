Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0ERWGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:06:38 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:51470 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752654Ab0ERWGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:06:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qH5I7Aipx2/Ihda1b57W1uDi3U4G+ZQxwfSDXswrwudiGPdac8MgdwDikP5kX4IzaIyzcItkjp2R8RdfnoowU64+q7iF/f5VkKeAThzkFqgeReI2SOVNa1yV7IpBPDDt;
Date: Tue, 18 May 2010 15:05:13 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update] Re: [RFC][PATCH] PM / PCI: Update PCI power management
 documentation
Message-ID: <20100518150513.050bb794@virtuousgeek.org>
In-Reply-To: <201005180023.24885.rjw@sisk.pl>
References: <201005162149.31770.rjw@sisk.pl>
	<4BF0B1C5.4060601@oracle.com>
	<201005180023.24885.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 00:23:24 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 17 May 2010, Randy Dunlap wrote:
> > On 05/16/10 12:49, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > I've just finished rewriting the PCI PM documentation.  I hope I didn't forget
> > > of anything important, so please let me know if I did.
> > > 
> > > Generally, please let me know what you think.
> > 
> > Hi,
> > 
> > It reads pretty well IMO.
> > 
> > I have corrected several typos etc.
> > I have also noted a need for explaining *why* something is being done,
> > not just what is being done.
> 
> Thanks a lot for the very useful comments.  I did my best to address them all
> and the modified (and hopefully improved patch) is appended.
> 
> > There may be a few other places where some justification is needed
> > (i.e., would be helpful).
> 
> Well, in fact it is quite difficult to me to identify places where such a
> justification would be useful, because I know how all of this works. :-)
> Fortunately, the justification is usually given in the other two documents this
> one refers to.
> 

Applied, thanks guys.

-- 
Jesse Barnes, Intel Open Source Technology Center
