Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2DRNm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:42:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36559 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2DRNm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:42:57 -0400
Date: Wed, 18 Apr 2012 22:42:51 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, kvm-ppc@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
Message-Id: <20120418224251.d832fc4728e6f2114f59a3b1@gmail.com>
In-Reply-To: <4F8D8498.4080409@redhat.com>
References: <4F742951.7080003@linux.vnet.ibm.com>
	<4F82E04E.6000900@redhat.com>
	<20120409175829.GB21894@amt.cnet>
	<4F8329D3.7000605@gmail.com>
	<20120409194614.GB23053@amt.cnet>
	<4F840DD2.3090101@redhat.com>
	<20120410204031.ffb5b976225ac9fe6dae474e@gmail.com>
	<4F842074.1050108@linux.vnet.ibm.com>
	<20120411211514.35db29c11460516e604059b6@gmail.com>
	<4F857B61.9080602@linux.vnet.ibm.com>
	<20120411231441.9d0984672dd252b806f99128@gmail.com>
	<20120413232528.c5ddbddb3cc0870d6e85a332@gmail.com>
	<4F8A95CB.9070104@redhat.com>
	<20120417004935.a9a39d951b3c24588e29edd2@gmail.com>
	<4F8D0D29.9050009@linux.vnet.ibm.com>
	<4F8D210C.8070505@redhat.com>
	<20120417213748.f3c4ae8d0056676fd33a47c5@gmail.com>
	<4F8D6503.4040800@redhat.com>
	<20120417235450.c0972c06034002d7173eeb40@gmail.com>
	<4F8D8498.4080409@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 17:56:24 +0300
Avi Kivity <avi@redhat.com> wrote:

> > For live migration, range-based control may be enough duo to the locality
> > of WWS.
> 
> What's WWS?

IIRC it was mentioned in a usenix paper: Writable Working Set.

May not be a commonly known concept.
Kind of working set, but is written often.

> I don't see a reason to assume locality in gpa space (or in gva space
> either, for some workloads).

Sorry, I may be wrong.

I once thought to log dirty_bitmaps during live migration, but didn't.

Thanks,
	Takuya
