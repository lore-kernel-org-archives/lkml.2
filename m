Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2FNBPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:15:35 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35647 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2FNBPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:15:33 -0400
Date: Thu, 14 Jun 2012 10:22:14 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 6/9] KVM: MMU: fast path of handling guest page fault
Message-Id: <20120614102214.1c8a6e23.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120613224002.GE19290@amt.cnet>
References: <4FC470C7.5040700@linux.vnet.ibm.com>
	<4FC471B8.3070204@linux.vnet.ibm.com>
	<20120613224002.GE19290@amt.cnet>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 19:40:02 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> mmu_spte_update is handling several different cases. Please rewrite
> it, add a comment on top of it (or spread comments on top of each
> significant code line) with all cases it is handling (also recheck it
> regarding new EPT accessed/dirty bits code).

[not about this patch]

EPT accessed/dirty bits will be used for more things in the future.
Are there any rules for using these bits?

Same as other bits?

	Takuya
