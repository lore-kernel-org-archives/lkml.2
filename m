Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0LAXeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 18:34:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab0LAXeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 18:34:06 -0500
Date: Wed, 1 Dec 2010 18:42:50 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: MMU: fix accessed bit set on prefault path
Message-ID: <20101201204250.GA18395@amt.cnet>
References: <4CF4C535.8080405@cn.fujitsu.com>
 <4CF4C587.7080000@cn.fujitsu.com>
 <20101130132915.GG2187@redhat.com>
 <4CF52BC6.9020401@cn.fujitsu.com>
 <20101130175005.GA2924@redhat.com>
 <4CF53F41.1040503@cn.fujitsu.com>
 <20101130183833.GB2924@redhat.com>
 <4CF54C4F.80901@cn.fujitsu.com>
 <20101130192059.GC2924@redhat.com>
 <4CF5B0F6.8030900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF5B0F6.8030900@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 10:20:38AM +0800, Xiao Guangrong wrote:
> On 12/01/2010 03:20 AM, Gleb Natapov wrote:
> 
> > Firs of all if guest is PV the guest process cannot be killed. Second
> > why is it a problem that we marked pfn as accessed on speculative path?
> > What problem it causes especially since it is very likely that the page
> > will be accessed shortly anyway?
> > 
> 
> Hi Avi, Marcelo,
> 
> What is your opinion on this point?

Dont think this is an issue. Its very likely the page is going to be
accessed soon (unlike pte prefetch).

