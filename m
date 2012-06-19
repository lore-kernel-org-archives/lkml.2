Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2FSCHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:07:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49458 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2FSCHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:07:33 -0400
Date: Tue, 19 Jun 2012 11:07:28 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 6/9] KVM: MMU: fast path of handling guest page fault
Message-Id: <20120619110728.14504b91ec1c2ee9cd81b413@gmail.com>
In-Reply-To: <20120618192120.GA2697@amt.cnet>
References: <4FC470C7.5040700@linux.vnet.ibm.com>
	<4FC471B8.3070204@linux.vnet.ibm.com>
	<20120613224002.GE19290@amt.cnet>
	<20120614102214.1c8a6e23.yoshikawa.takuya@oss.ntt.co.jp>
	<20120618192120.GA2697@amt.cnet>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 16:21:20 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> > [not about this patch]
> > 
> > EPT accessed/dirty bits will be used for more things in the future.
> > Are there any rules for using these bits?
> > 
> > Same as other bits?
> 
> Do you mean hardware rules or KVM rules?

KVM rules.

Your concern was about "lock-less" v. "current EPT-A/D code".
My question was what we should care not to break the former
in the future.

	Takuya
