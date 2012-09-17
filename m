Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2IQSGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:06:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39101 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2IQSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:06:48 -0400
MIME-Version: 1.0
In-Reply-To: <1345133009-21941-12-git-send-email-konrad.wilk@oracle.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com> <1345133009-21941-12-git-send-email-konrad.wilk@oracle.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Mon, 17 Sep 2012 20:06:26 +0200
Message-ID: <CAJ75kXYG3uPmMhUwB9ivHt0w5gm14aqAynSWQwooWg65xLTzPw@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 11/11] xen/mmu: Release just the MFN list, not
 MFN list and part of pagetables.
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Konrad,

On Thu, Aug 16, 2012 at 6:03 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> (XEN) mm.c:908:d0 Error getting mfn 116a83 (pfn 14e2a) from L1 entry 8000000116a83067 for l1e_owner=0, pg_owner=0
> (XEN) mm.c:908:d0 Error getting mfn 4040 (pfn 5555555555555555) from L1 entry 0000000004040601 for l1e_owner=0, pg_owner=0

This is something I also have on my 3.4.x branch. Since then mmu.c has
change a lot; is there an easy fix to make a backport for 3.4.x?

-- 
William
