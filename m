Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab1L3KO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 05:14:26 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:44138 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1L3KOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 05:14:22 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <20111230095147.GA10543@elte.hu>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Fri, 30 Dec 2011 15:40:06 +0530
Message-ID: <878vlu4bgh.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11123010-5564-0000-0000-000000B8017B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Dec 2011 10:51:47 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > [...]
> > 
> > The first part appears to be unrelated to ebizzy itself - it's 
> > the kunmap_atomic() flushing ptes.  It could be eliminated by 
> > switching to a non-highmem kernel, or by allocating more PTEs 
> > for kmap_atomic() and batching the flush.
> 
> Nikunj, please only run pure 64-bit/64-bit combinations - by the 
> time any fix goes upstream and trickles down to distros 32-bit 
> guests will be even less relevant than they are today.
> 
Sure Ingo, got a 64bit guest working yesterday and I am in process of
getting the benchmark numbers for the same.

Regards,
Nikunj


