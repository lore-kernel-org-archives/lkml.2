Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0GIQDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:03:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab0GIQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:03:48 -0400
Date: Fri, 9 Jul 2010 12:03:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: akpm@linux-foundation.org, mingo@redhat.com, hugh.dickins@tiscali.co.uk,
       riel@redhat.com, peterz@infradead.org, anton@samba.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] Add trace events to mmap and brk
Message-ID: <20100709160342.GB3281@infradead.org>
References: <1278690830-22145-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278690830-22145-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, thinking about it a bit more, what do you trace events give us that
the event based syscall tracer doesn't?

