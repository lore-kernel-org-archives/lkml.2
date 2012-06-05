Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284Ab2FENbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:31:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:46075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934255Ab2FENbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:31:53 -0400
Message-ID: <1338903092.28282.176.camel@twins>
Subject: Re: [PATCH v2 6/7] kvm,x86: RCU based table free
From: Peter Zijlstra <peterz@infradead.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "raghukt@linux.vnet.ibm.com" <raghukt@linux.vnet.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "jeremy@goop.org" <jeremy@goop.org>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Tue, 05 Jun 2012 15:31:32 +0200
In-Reply-To: <alpine.DEB.2.02.1206051422500.6030@kaball.uk.xensource.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
	  <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com>
	  <alpine.DEB.2.02.1206051137270.6030@kaball.uk.xensource.com>
	  <87ehpuqam8.fsf@linux.vnet.ibm.com>
	  <alpine.DEB.2.02.1206051232270.6030@kaball.uk.xensource.com>
	 <878vg1rjts.fsf@linux.vnet.ibm.com> <1338901688.28282.168.camel@twins>
	 <alpine.DEB.2.02.1206051422500.6030@kaball.uk.xensource.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 14:26 +0100, Stefano Stabellini wrote:
> On Tue, 5 Jun 2012, Peter Zijlstra wrote:
> > On Tue, 2012-06-05 at 18:34 +0530, Nikunj A Dadhania wrote:
> > > PeterZ, is 7/7 alright to be picked?
> > 
> > Yeah, I guess it is.. I haven't had time to rework my tlb series yet
> > though. But these two patches together should make it work for x86.
> > 
> 
> Good. Do you think they are OK for 3.5-rc2? Or is it better to wait for
> 3.6?

I wouldn't rush this stuff, but if you're up for it and can convince
Linus that its all peachy you can try ;-)
