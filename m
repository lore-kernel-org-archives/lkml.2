Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1DYWt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 18:49:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255Ab1DYWt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 18:49:27 -0400
Date: Mon, 25 Apr 2011 15:48:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memblock: add error return when
 CONFIG_HAVE_MEMBLOCK is not set
Message-Id: <20110425154835.7d41d89e.akpm@linux-foundation.org>
In-Reply-To: <20110425181136.211858618@gulag1.americas.sgi.com>
References: <20110425181136.055235992@gulag1.americas.sgi.com>
	<20110425181136.211858618@gulag1.americas.sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 13:11:37 -0500
Mike Travis <travis@sgi.com> wrote:

> 	Add an error return if CONFIG_HAVE_MEMBLOCK is not set instead
> 	of having to add #ifdef CONFIG_HAVE_MEMBLOCK around blocks of
> 	code calling that function.
> 
> Authored-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Mike Travis <travis@sgi.com>

There is no such thing as "Authored-by:".  If this patch was written by
yinghai then it must be tagged as From:him at the top of the changelog
and preferably has his signed-off-by: at the end.

Please clarify?
