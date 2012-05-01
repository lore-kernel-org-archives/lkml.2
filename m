Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2EALAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 07:00:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:58769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab2EALAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 07:00:15 -0400
Message-ID: <1335869998.13683.135.camel@twins>
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Date: Tue, 01 May 2012 12:59:58 +0200
In-Reply-To: <1335869827.13683.133.camel@twins>
References: <20120427161727.27082.43096.stgit@abhimanyu>
	 <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com>
	 <1335865176.13683.120.camel@twins> <4F9FBF38.2060903@redhat.com>
	 <1335869827.13683.133.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 12:57 +0200, Peter Zijlstra wrote:
> Anyway, I don't have any idea about the costs involved with
> HAVE_RCU_TABLE_FREE, but I don't think its much.. otherwise these other
> platforms (PPC,SPARC) wouldn't have used it, gup_fast() is a very
> specific case, whereas mmu-gather is something affecting pretty much all
> tasks. 

Which reminds me, I thought Xen needed this too, but a git grep on
HAVE_RCU_TABLE_FREE shows its still only ppc and sparc.

Jeremy?
