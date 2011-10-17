Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1JQWjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:39:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63683 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab1JQWjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:39:39 -0400
Date: Mon, 17 Oct 2011 15:39:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Ballard <dan@mindstab.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/sysctl.c: Add cap_last_cap to
 /proc/sys/kernel
Message-Id: <20111017153936.c47a27ff.akpm@linux-foundation.org>
In-Reply-To: <1318690205-2731-1-git-send-email-dan@mindstab.net>
References: <1318460194-31983-1-git-send-email-dan@mindstab.net>
	<1318690205-2731-1-git-send-email-dan@mindstab.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011 07:50:05 -0700
Dan Ballard <dan@mindstab.net> wrote:

> Userspace needs to know the highest valid capability of the running
> kernel, which right now cannot reliably be retrieved from the header
> files only.  The fact that this value cannot be determined properly
> right now creates various problems for libraries compiled on newer
> header files which are run on older kernels. They assume
> capabilities are available which actually aren't.

Specfically, what libraries are we talking about here?

> Now the capability is exported in /proc/sys/kernel/cap_last_cap.

Ever the optimist: is there any way in which we can avoid 0444
permissions on this?
