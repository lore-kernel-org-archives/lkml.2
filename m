Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030317Ab2CBW6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:58:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965354Ab2CBW6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:58:14 -0500
Date: Fri, 2 Mar 2012 14:58:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Dave Jones <davej@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kernel-team@fedoraproject.org
Subject: Re: exit_mmap() BUG_ON triggering since 3.1
Message-Id: <20120302145811.93bb49e9.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1203021444040.3448@eggly.anvils>
References: <20120215183317.GA26977@redhat.com>
	<alpine.LSU.2.00.1202151801020.19691@eggly.anvils>
	<20120216070753.GA23585@redhat.com>
	<alpine.LSU.2.00.1202160130500.16147@eggly.anvils>
	<20120216214245.GD23585@redhat.com>
	<alpine.LSU.2.00.1203021444040.3448@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012 14:53:32 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> Subject: Re: exit_mmap() BUG_ON triggering since 3.1
> ...
> Subject: [PATCH] mm: thp: fix BUG on mm->nr_ptes

So it's needed in 3.1.x and 3.2.x?
