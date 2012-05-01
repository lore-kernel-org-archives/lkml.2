Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2EAS3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:29:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55712 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2EAS3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:29:37 -0400
Date: Tue, 1 May 2012 20:29:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH RFC 3/3] proc/smaps: show amount of hwpoison pages
Message-ID: <20120501182932.GR27374@one.firstfloor.org>
References: <20120430112903.14137.81692.stgit@zurg> <20120430112910.14137.28935.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430112910.14137.28935.stgit@zurg>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 03:29:11PM +0400, Konstantin Khlebnikov wrote:
> This patch adds line "HWPoinson: <size> kB" into /proc/pid/smaps if
> CONFIG_MEMORY_FAILURE=y and some HWPoison pages were found.
> This may be useful for searching applications which use a broken memory.

Makes sense. The kernel will log the process names, but it can be useful to
look for it after the fact to get a more complete picture of the state
of the machine.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
