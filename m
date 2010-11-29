Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab0K2I7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:59:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41444 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0K2I7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:59:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LicNOWB3T3/gyBgCgY7xnqsyQ/9zrl9bgMhAbXo0ka8sI/ORXuaBxlc0M6lhgR69TC
         M0IcgNbrhsAl3X7BAA6FiAo2uuY63LFXnn/N2dzKOq51/SvaS06H1TQnzweB3DCsaNeq
         jLay2HMvS5rpaPkNNTNvRpAPxJst6Lg/f/qKQ=
Date: Mon, 29 Nov 2010 17:03:56 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kthread: NUMA aware kthread_create_on_cpu()
Message-ID: <20101129090356.GG5218@cr0.nay.redhat.com>
References: <1290972833.29196.90.camel@edumazet-laptop>
 <20101128224024.GA12300@basil.fritz.box>
 <1290984712.29196.100.camel@edumazet-laptop>
 <20101128230146.GB12300@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101128230146.GB12300@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 12:01:47AM +0100, Andi Kleen wrote:
>
>task_struct is always allocated from slab.
>

IA64 is an exception, it has its own alloc_task_struct()
which is simply __get_free_pages().
