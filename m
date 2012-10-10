Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab2JJBPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:15:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2JJBO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:14:58 -0400
Date: Tue, 9 Oct 2012 18:16:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
Message-Id: <20121009181639.36beafbe.akpm@linux-foundation.org>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930A33CD2@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-1-git-send-email-kys@microsoft.com>
	<20121008004358.GA12342@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF930A1FB31@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20121008133539.GA15490@kroah.com>
	<20121009124755.ce1087b4.akpm@linux-foundation.org>
	<426367E2313C2449837CD2DE46E7EAF930A33CD2@SN2PRD0310MB382.namprd03.prod.outlook.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 00:11:28 +0000 KY Srinivasan <kys@microsoft.com> wrote:

> 
> 
> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > Sent: Tuesday, October 09, 2012 3:48 PM
> > To: Greg KH
> > Cc: KY Srinivasan; olaf@aepfle.de; linux-kernel@vger.kernel.org;
> > andi@firstfloor.org; apw@canonical.com; devel@linuxdriverproject.org
> > Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
> > 
> > On Mon, 8 Oct 2012 06:35:39 -0700
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Mon, Oct 08, 2012 at 03:35:50AM +0000, KY Srinivasan wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > > > Sent: Sunday, October 07, 2012 8:44 PM
> > > > > To: KY Srinivasan
> > > > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > olaf@aepfle.de;
> > > > > apw@canonical.com; akpm@linux-foundation.org; andi@firstfloor.org
> > > > > Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
> > > > >
> > > > > On Sun, Oct 07, 2012 at 04:59:45PM -0700, K. Y. Srinivasan wrote:
> > > > > > The policy engine on the host expects the guest to report the
> > > > > > committed_as. Since this variable is not exported,
> > > > > > export this symbol.
> > > > >
> > > > > Why are these symbols not needed by either Xen or KVM or vmware, which
> > > > > I think all support the same thing, right?
> > > >
> > > > The basic balloon driver does not need this symbol since the basic balloon
> > driver
> > > > is not automatically driven by the host. On the Windows host we have a policy
> > engine that
> > > > drives the balloon driver based on both guest level memory pressure that the
> > guest
> > > > reports as well as other system level metrics the host maintains. We need this
> > symbol to
> > > > drive the policy engine on the host.
> > >
> > > Ok, but you're going to have to get the -mm developers to agree that
> > > this is ok before I can accept it.
> > 
> > Well I guess it won't kill us.
> 
> 
> Thanks.
> 

The other part of my email seems to have vanished.  Which makes me sad,
because I was rather interested in the answer.

