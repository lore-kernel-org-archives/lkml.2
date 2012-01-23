Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2AWUgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:36:43 -0500
Received: from matrixpower.ru ([195.178.208.66]:50282 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753303Ab2AWUgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:36:41 -0500
Date: Mon, 23 Jan 2012 23:36:38 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, neilb@suse.de
Subject: Re: [PATCH] W1: OMAP HDQ1W: use 32-bit register accesses
Message-ID: <20120123203638.GA8313@ioremap.net>
References: <alpine.DEB.2.00.1201221319270.26641@utopia.booyaka.com>
 <20120123150753.GA21395@ioremap.net>
 <alpine.DEB.2.00.1201231155590.29673@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201231155590.29673@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 11:57:09AM -0700, Paul Walmsley (paul@pwsan.com) wrote:
> http://www.spinics.net/lists/arm-kernel/msg156572.html

Well, if runtime PM does its job for clock manipulation properly, then
things should be fine. I suppose that ->probe() will fire up first and
you say it boots and detects w1 properly, so patch looks good.
Feel free to add my ack

-- 
	Evgeniy Polyakov
