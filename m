Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1AVUxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:53:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52487 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1AVUxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:53:08 -0500
Date: Sat, 22 Jan 2011 15:53:00 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pekka Enberg <penberg@kernel.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dima Zavin <dmitriyz@google.com>, Joe Perches <joe@perches.com>,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110122205300.GC8666@infradead.org>
References: <1295632828.19880.22.camel@m0nster>
 <20110121100441.06a94482@jbarnes-desktop>
 <1295633882.19880.31.camel@m0nster>
 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
 <1295642995.19880.42.camel@m0nster>
 <1295643762.25868.31.camel@Joe-Laptop>
 <1295645098.22882.1.camel@m0nster>
 <AANLkTi=mvdfpCPefGeDr+eGxpSUr3is5jgugHtgB-m1w@mail.gmail.com>
 <20110122122018.GC5194@n2100.arm.linux.org.uk>
 <AANLkTi=47z21zExtfHq2WYdUdXeC1rNhe7vQsqPkFsMi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=47z21zExtfHq2WYdUdXeC1rNhe7vQsqPkFsMi@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 11:22:57AM -0800, Brian Swetland wrote:
> What would be useful would be a reasonable convention for
> acknowledging multiple authors, perhaps something along the lines of:

If you do a grep "Based on" in git-log output you'll see that this is a
pretty common and thus defacto standard for attributing substantial
modified patches.

