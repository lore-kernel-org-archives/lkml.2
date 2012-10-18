Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2JRUQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:16:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55888 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2JRUQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:16:06 -0400
Date: Thu, 18 Oct 2012 13:16:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bob Liu <lliubbo@gmail.com>
cc: akpm@linux-foundation.org, aarcange@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com, hughd@google.com,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com
Subject: Re: [PATCH 3/4] thp: introduce hugepage_vma_check()
In-Reply-To: <1350555140-11030-3-git-send-email-lliubbo@gmail.com>
Message-ID: <alpine.DEB.2.00.1210181315480.26994@chino.kir.corp.google.com>
References: <1350555140-11030-1-git-send-email-lliubbo@gmail.com> <1350555140-11030-3-git-send-email-lliubbo@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Bob Liu wrote:

> Multi place do the same check.
> 

This only succeeds in removing four lines and makes the code more 
difficult to follow, nack.
