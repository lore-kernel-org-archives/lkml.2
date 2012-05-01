Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2EAW2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:28:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2EAW2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:28:30 -0400
Date: Tue, 1 May 2012 15:28:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 00/16] Swap-over-NBD without deadlocking V9
Message-Id: <20120501152826.b970a098.akpm@linux-foundation.org>
In-Reply-To: <1334578624-23257-1-git-send-email-mgorman@suse.de>
References: <1334578624-23257-1-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is far less ghastly than I feared/remembered/dreamed ;)

The mm parts, anyway.  Are the net guys on board with it all?
