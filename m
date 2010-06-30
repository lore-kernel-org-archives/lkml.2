Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0F3HcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:32:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab0F3Hb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:31:59 -0400
Date: Wed, 30 Jun 2010 03:31:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Yama: add PTRACE exception tracking
Message-ID: <20100630073158.GA4453@infradead.org>
References: <20100630003844.GE4837@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630003844.GE4837@outflux.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Err, no.  This is just a very clear sign that your ptrace restrictions
were completely wrong to start with and break applications left, right
and center.  Just get rid of it instead of letting workarounds for your
bad design creep into the core kernel and applications.

