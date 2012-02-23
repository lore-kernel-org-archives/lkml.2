Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2BWUWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:22:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2BWUWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:22:17 -0500
Date: Thu, 23 Feb 2012 12:22:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
Message-Id: <20120223122215.d280b090.akpm@linux-foundation.org>
In-Reply-To: <1329969811-3997-1-git-send-email-siddhesh.poyarekar@gmail.com>
References: <20120222150010.c784b29b.akpm@linux-foundation.org>
	<1329969811-3997-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 09:33:31 +0530
Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:

> With this patch in place, /proc/PID/task/TID/maps are treated as 'maps
> as the task would see it' and hence, only the vma that that task uses
> as stack is marked as [stack]. All other 'stack' vmas are marked as
> anonymous memory. /proc/PID/maps acts as a thread group level view,
> where all stack vmas are marked.

Looks OK to me, thanks.  I doubt if those interface changes will cause
significant disruption.

