Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2LLVuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:50:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2LLVuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:50:20 -0500
Date: Wed, 12 Dec 2012 13:50:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] page reclaim bits
Message-Id: <20121212135019.ffa417bc.akpm@linux-foundation.org>
In-Reply-To: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2012 16:43:32 -0500
Johannes Weiner <hannes@cmpxchg.org> wrote:

> I had these in my queue and on test machines for a while, but they got
> deferred over and over, partly because of the kswapd issues.  I hope
> it's not too late for 3.8, they should be fairly straight forward.

um, that is rather late.

Let's review these promptly and thoroughly, please.  Then we can look
at squeaking at least the simple and/or observably-beneficial ones into
-rc1 or -rc2.

