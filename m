Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024Ab0J0MAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:00:47 -0400
Received: from verein.lst.de ([213.95.11.210]:40718 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759948Ab0J0MAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:00:46 -0400
Date: Wed, 27 Oct 2010 13:59:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, eric.dumazet@gmail.com, davem@davemloft.net,
        hch@lst.de, holt@sgi.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 116/176] fs: allow for more than 2^31 files
Message-ID: <20101027115946.GA26335@lst.de>
References: <201010262122.o9QLMiZG016728@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010262122.o9QLMiZG016728@imap1.linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch breaks the binary sysctl ABI.  It probably doesn't matter
as no one actually used it, but it might be better idea to just remove
this node from the binary sysctl tree.

