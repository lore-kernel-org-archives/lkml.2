Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2JRUPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:15:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44396 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab2JRUPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:15:18 -0400
Date: Thu, 18 Oct 2012 13:15:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bob Liu <lliubbo@gmail.com>
cc: akpm@linux-foundation.org, aarcange@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com, hughd@google.com,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com
Subject: Re: [PATCH 2/4] thp: introduce hugepage_get_pmd()
In-Reply-To: <1350555140-11030-2-git-send-email-lliubbo@gmail.com>
Message-ID: <alpine.DEB.2.00.1210181314380.26994@chino.kir.corp.google.com>
References: <1350555140-11030-1-git-send-email-lliubbo@gmail.com> <1350555140-11030-2-git-send-email-lliubbo@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Bob Liu wrote:

> Introduce hugepage_get_pmd() to simple code.
> 

I don't see this as simple just because you're removing more lines, I find 
pagetable walks to be harder to read when split up like this and the "get" 
part implies you're grabbing a reference on the pmd, which you're not.
