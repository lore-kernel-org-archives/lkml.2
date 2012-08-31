Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2HaIH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:07:28 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58600 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2HaIHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:07:25 -0400
MIME-Version: 1.0
In-Reply-To: <50406F60.5040707@intel.com>
References: <1342139517-3451-1-git-send-email-walken@google.com>
	<1342139517-3451-8-git-send-email-walken@google.com>
	<50406F60.5040707@intel.com>
Date: Fri, 31 Aug 2012 01:07:24 -0700
Message-ID: <CANN689EBA6yPk3pS-yXZ1-ticG7eU3mY1mWMWp2S3xhJ73ODFA@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] rbtree: adjust root color in rb_insert_color()
 only when necessary
From: Michel Lespinasse <walken@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, acme@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 1:01 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> This breaks tools/perf build in linux-next:
>
> ../../lib/rbtree.c: In function 'rb_insert_color':
> ../../lib/rbtree.c:95:9: error: 'true' undeclared (first use in this function)
> ../../lib/rbtree.c:95:9: note: each undeclared identifier is reported only once for each function it appears in
> ../../lib/rbtree.c: In function '__rb_erase_color':
> ../../lib/rbtree.c:216:9: error: 'true' undeclared (first use in this function)
> ../../lib/rbtree.c: In function 'rb_erase':
> ../../lib/rbtree.c:368:2: error: unknown type name 'bool'
> make: *** [util/rbtree.o] Error 1

I thought Andrew had a patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation
that fixed this though a Makefile change ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
