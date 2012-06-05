Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab2FEN0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:26:44 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:6774 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934012Ab2FEN0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:26:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,718,1330905600"; 
   d="scan'208";a="12840105"
Date: Tue, 5 Jun 2012 14:26:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Peter Zijlstra <peterz@infradead.org>
CC: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
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
Subject: Re: [PATCH v2 6/7] kvm,x86: RCU based table free
In-Reply-To: <1338901688.28282.168.camel@twins>
Message-ID: <alpine.DEB.2.02.1206051422500.6030@kaball.uk.xensource.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>  <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com>  <alpine.DEB.2.02.1206051137270.6030@kaball.uk.xensource.com>  <87ehpuqam8.fsf@linux.vnet.ibm.com>  <alpine.DEB.2.02.1206051232270.6030@kaball.uk.xensource.com>
  <878vg1rjts.fsf@linux.vnet.ibm.com> <1338901688.28282.168.camel@twins>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 18:34 +0530, Nikunj A Dadhania wrote:
> > PeterZ, is 7/7 alright to be picked?
> 
> Yeah, I guess it is.. I haven't had time to rework my tlb series yet
> though. But these two patches together should make it work for x86.
> 

Good. Do you think they are OK for 3.5-rc2? Or is it better to wait for
3.6?
