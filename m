Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab1EFWkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:40:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666Ab1EFWkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:40:07 -0400
Date: Fri, 6 May 2011 15:39:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Hellermann <stefan@the2masters.de>,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH] mm: Use alloc_bootmem_node_nopanic on really needed path
Message-Id: <20110506153914.b1bceb51.akpm@linux-foundation.org>
In-Reply-To: <4DC47655.5040201@kernel.org>
References: <4DC30251.9040902@the2masters.de>
	<4DC31D5F.8070209@the2masters.de>
	<4DC31F72.5050206@kernel.org>
	<4DC328AC.1060906@the2masters.de>
	<4DC3958F.1090800@kernel.org>
	<4DC3B6C6.7000704@the2masters.de>
	<4DC47655.5040201@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 May 2011 15:29:41 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> Stefan found nobootmem does not work on his system that only have 8M ram.

What does "does not work" mean?  From the patch, it appears that the
machine paniced?

This is important because without a recognisable description of the
failure it is hard for people to determine whether your patch might fix
a problem which they are observing.

The patch applies to 2.6.36, 37 and 38 (at least).  Do you think it
should be backported?  If so, how far back in time is it applicable?

