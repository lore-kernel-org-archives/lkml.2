Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1L0KPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 05:15:04 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59332 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1L0KPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 05:15:01 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4EF99532.3010803@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <87vcp4t45p.fsf@linux.vnet.ibm.com> <877h1iu2md.fsf@linux.vnet.ibm.com> <4EF98D29.1080809@redhat.com> <87ty4mic23.fsf@abhimanyu.in.ibm.com> <4EF99532.3010803@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 27 Dec 2011 15:40:51 +0530
Message-ID: <87obuuiatw.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122710-4790-0000-0000-00000097821B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 11:51:46 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/27/2011 11:44 AM, Nikunj A Dadhania wrote:
> > > > I am seeing a drop of ~44% when setting yield_on_hlt = 0
> > > >
> > > 
> > > A drop of 44% of what?
> > > 
> > records/sec
> >
> > Ebizzy - 2VM running in parallel, both having gang scheduling enabled.
> >
> >                     yield_on_hlt=1         yield_on_hlt=0
> >  EbzyRecords/sec      41955.50               23285.00            -44 
> >
> >
> 
> Interesting, are you overcommitting vcpus?
> 
Yes(1:2). On a 8cpu machine, have 2VMs running, which is 8vcpus each.

Regards
Nikunj

