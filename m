Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1HVOcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:32:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1HVOct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:32:49 -0400
Date: Mon, 22 Aug 2011 11:32:35 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 02/11] KVM: x86: tag the instructions which are used to
 write page table
Message-ID: <20110822143235.GA4797@amt.cnet>
References: <4E4A10E8.5090705@cn.fujitsu.com>
 <4E4A1117.1030608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4A1117.1030608@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 02:41:27PM +0800, Xiao Guangrong wrote:
> The idea is from Avi:
> | tag instructions that are typically used to modify the page tables, and
> | drop shadow if any other instruction is used.
> | The list would include, I'd guess, and, or, bts, btc, mov, xchg, cmpxchg,
> | and cmpxchg8b.
> 
> This patch is used to tag the instructions and in the later path, shadow page
> is dropped if it is written by other instructions

What is the advantage of doing this again? What is the point of
dropping shadow if the instruction is emulated?

