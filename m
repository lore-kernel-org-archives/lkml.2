Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab0LTPxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:53:40 -0500
Received: from freeflow.nu ([178.79.134.28]:34566 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010Ab0LTPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:53:38 -0500
Subject: Re: [PATCHSET percpu#this_cpu_ops] add
 this_cpu_{add_return|[cmp]xchg}() operations
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, hpa@zytor.com, mathieu.desnoyers@efficios.com
In-Reply-To: <1292685852-12469-1-git-send-email-tj@kernel.org>
References: <1292685852-12469-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 20 Dec 2010 17:53:35 +0200
Message-ID: <1292860415.4434.1.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-18 at 16:24 +0100, Tejun Heo wrote:
> Hello,
> 
> Here are the patches that I applied to percpu#this_cpu_ops branch.
> This branch won't be rebased and contains only the commits which
> implement the new this_cpu_* ops, so that it can be pulled into other
> trees without patches which make use of the operations which modify
> other subsystems.
> 
> Christoph, I rearranged things a bit to make it conform better to the
> overall organization.  It would be great if you can go over it once
> just in case.
> 
> There are two git branches.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git this_cpu_ops
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-2.6.38
> 
> Both branches won't be rebased.  this_cpu_ops contains only patches
> from this series.  for-2.6.38 contains other percpu changes mostly
> composed of patches which apply this_cpu_*() ops.

Thanks. Christoph, mind sending me the slub patches? There's been so
many I've lost track which one is the latest.

			Pekka

