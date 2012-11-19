Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2KSVhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:37:03 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41487 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2KSVhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:37:00 -0500
Date: Mon, 19 Nov 2012 13:36:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/58] mm: include/linux/huge_mm.h: Declare is_vma_temporary_stack
 unconditionally
In-Reply-To: <1353302917-13995-25-git-send-email-josh@joshtriplett.org>
Message-ID: <alpine.DEB.2.00.1211191336460.12532@chino.kir.corp.google.com>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org> <1353302917-13995-25-git-send-email-josh@joshtriplett.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1924761905-1353361019=:12532"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1924761905-1353361019=:12532
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 18 Nov 2012, Josh Triplett wrote:

> include/linux/huge_mm.h declares is_vma_temporary_stack inside an ifdef
> CONFIG_TRANSPARENT_HUGEPAGE; however, mm/rmap.c defines the function
> unconditionally.  Move the function outside of the ifdef.
> 
> This eliminates a warning from gcc (-Wmissing-prototypes) and from
> Sparse (-Wdecl).
> 
> mm/rmap.c:1440:6: warning: no previous prototype for ‘is_vma_temporary_stack’ [-Wmissing-prototypes]
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: David Rientjes <rientjes@google.com>
--531381512-1924761905-1353361019=:12532--
