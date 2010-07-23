Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0GWQ1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:27:54 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:38216 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753044Ab0GWQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:27:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=aVj5/04M+s8OfAh2w6FP7DBfB6M5iGIdU0zklZ0mQ1Iju1Y2lrimp8UdjBj0iIJS6+n7rwm/V+fbyq70+gJHH5Bn7saHGeEPCOdwvm+cuvdY2hhrtrCbI2bZyCgfP2tH;
Date: Fri, 23 Jul 2010 09:28:06 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, chrisw@redhat.com,
        ddutile@redhat.com, bjorn.helgaas@hp.com, eike-kernel@sf-tec.de
Subject: Re: [PATCH v2] pci: Allow read/write access to sysfs I/O port
 resources
Message-ID: <20100723092806.58ef884f@virtuousgeek.org>
In-Reply-To: <1279897827.4601.89.camel@x201>
References: <20100719031148.13524.25354.stgit@localhost6.localdomain6>
	<20100719154321.11535.39055.stgit@localhost6.localdomain6>
	<1279897827.4601.89.camel@x201>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 09:10:27 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 2010-07-19 at 09:45 -0600, Alex Williamson wrote:
> > PCI sysfs resource files currently only allow mmap'ing.  On x86 this
> > works fine for memory backed BARs, but doesn't work at all for I/O
> > port backed BARs.  Add read/write to I/O port PCI sysfs resource
> > files to allow userspace access to these device regions.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> 
> Any thoughts on this for -next?  Thanks,

Yeah, I like it.  Unless there are objections I'll pull it in.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
