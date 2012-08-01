Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2HAMNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:13:04 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54954 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2HAMM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:12:59 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo\@elte.hu" <mingo@elte.hu>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        "avi\@redhat.com" <avi@redhat.com>,
        "raghukt\@linux.vnet.ibm.com" <raghukt@linux.vnet.ibm.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "jeremy\@goop.org" <jeremy@goop.org>,
        "vatsa\@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 6/7] kvm,x86: RCU based table free
In-Reply-To: <alpine.DEB.2.02.1208011221140.4645@kaball.uk.xensource.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com> <alpine.DEB.2.02.1206051137270.6030@kaball.uk.xensource.com> <87ehpuqam8.fsf@linux.vnet.ibm.com> <alpine.DEB.2.02.1206051232270.6030@kaball.uk.xensource.com> <878vg1rjts.fsf@linux.vnet.ibm.com> <1338901688.28282.168.camel@twins> <alpine.DEB.2.02.1206051422500.6030@kaball.uk.xensource.com> <alpine.DEB.2.02.1208011221140.4645@kaball.uk.xensource.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Wed, 01 Aug 2012 17:42:06 +0530
Message-ID: <87txwmlskp.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12080112-6102-0000-0000-000001FB300C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On Wed, 1 Aug 2012 12:23:37 +0100, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> On Tue, 5 Jun 2012, Stefano Stabellini wrote:
> > On Tue, 5 Jun 2012, Peter Zijlstra wrote:
> > > On Tue, 2012-06-05 at 18:34 +0530, Nikunj A Dadhania wrote:
> > > > PeterZ, is 7/7 alright to be picked?
> > > 
> > > Yeah, I guess it is.. I haven't had time to rework my tlb series yet
> > > though. But these two patches together should make it work for x86.
> > > 
> > 
> > Good. Do you think they are OK for 3.5-rc2? Or is it better to wait for
> > 3.6?
> > 
> 
> Hello Nikunj,
> what happened to this patch series?
> In particular I am interested in the following two patches:
> 
> kvm,x86: RCU based table free
> Flush page-table pages before freeing them
> 
> do you still intend to carry on with the development? Is there anything
> missing that is preventing them from going upstream?
>
I have posted a v3 on the kvm-list:
http://www.spinics.net/lists/kvm/msg76955.html

I am carrying the above two patches(with one fix) in my series as well
for completeness. 

I have picked up the patches from PeterZ's "Unify TLB gather
implementations -v3"
http://article.gmane.org/gmane.linux.kernel.mm/81278

Regards
Nikunj

