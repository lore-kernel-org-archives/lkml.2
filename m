Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2FEPaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:30:20 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55196 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2FEPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:30:18 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "mingo\@elte.hu" <mingo@elte.hu>,
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
In-Reply-To: <1338901688.28282.168.camel@twins>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com> <alpine.DEB.2.02.1206051137270.6030@kaball.uk.xensource.com> <87ehpuqam8.fsf@linux.vnet.ibm.com> <alpine.DEB.2.02.1206051232270.6030@kaball.uk.xensource.com> <878vg1rjts.fsf@linux.vnet.ibm.com> <1338901688.28282.168.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 05 Jun 2012 20:59:28 +0530
Message-ID: <8762b5rd47.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12060515-4790-0000-0000-000003180326
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2012 15:08:08 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-06-05 at 18:34 +0530, Nikunj A Dadhania wrote:
> > PeterZ, is 7/7 alright to be picked?
> 
> Yeah, I guess it is.. I haven't had time to rework my tlb series yet
> though. But these two patches together should make it work for x86.
>
I haven't added your SOB yet to this, though I have your name in
mentioned "From". Should I add your SOB to this, I have added a
minor fix for !CONFIG_HAVE_RCU_TABLE_FREE case?

Regards
Nikunj

