Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2JRUca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:32:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2JRUc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:32:26 -0400
Date: Thu, 18 Oct 2012 13:32:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Bob Liu <lliubbo@gmail.com>, aarcange@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com, hughd@google.com,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com
Subject: Re: [PATCH 3/4] thp: introduce hugepage_vma_check()
Message-Id: <20121018133225.53f0e247.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1210181315480.26994@chino.kir.corp.google.com>
References: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
	<1350555140-11030-3-git-send-email-lliubbo@gmail.com>
	<alpine.DEB.2.00.1210181315480.26994@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012 13:16:04 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 18 Oct 2012, Bob Liu wrote:
> 
> > Multi place do the same check.
> > 
> 
> This only succeeds in removing four lines and makes the code more 
> difficult to follow

I like it.  It takes a bunch of code sequences which may or may not be the
same and removes all doubt, while making the call sites clearer.
