Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab0D3TfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:35:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab0D3TfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:35:04 -0400
Date: Fri, 30 Apr 2010 16:33:25 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 7/10] KVM MMU: allow more page become unsync at gfn
 mapping time
Message-ID: <20100430193325.GA6023@amt.cnet>
References: <4BD7AE34.5000408@cn.fujitsu.com>
 <4BD7B1C5.10808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD7B1C5.10808@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:55:49AM +0800, Xiao Guangrong wrote:
> In current code, shadow page can become asynchronous only if one
> shadow page for a gfn, this rule is too strict, in fact, we can
> let all last mapping page(i.e, it's the pte page) become unsync,
> and sync them at invlpg or flush tlb time.
> 
> This patch allow more page become asynchronous at gfn mapping time 
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Xiao,

This patch breaks Fedora 8 32 install. Reverted patches 5-10.

