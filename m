Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2JKOTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:19:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58428 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2JKOTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:19:32 -0400
MIME-Version: 1.0
Date: Thu, 11 Oct 2012 11:19:30 -0300
Message-ID: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
Subject: [Q] Default SLAB allocator
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Cc: Tim Bird <tim.bird@am.sony.com>, celinux-dev@lists.celinuxforum.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While I've always thought SLUB was the default and recommended allocator,
I'm surprise to find that it's not always the case:

$ find arch/*/configs -name "*defconfig" | wc -l
452

$ grep -r "SLOB=y" arch/*/configs/ | wc -l
11

$ grep -r "SLAB=y" arch/*/configs/ | wc -l
245

This shows that, SLUB being the default, there are actually more
defconfigs that choose SLAB.

I wonder...

* Is SLAB a proper choice? or is it just historical an never been re-evaluated?
* Does the average embedded guy knows which allocator to choose
  and what's the impact on his platform?

Thanks,

   Ezequiel
