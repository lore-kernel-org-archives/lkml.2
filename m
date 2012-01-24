Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2AXIAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:00:51 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:55532 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2AXIAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:00:50 -0500
Date: Tue, 24 Jan 2012 01:00:49 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, neilb@suse.de
Subject: Re: [PATCH] W1: OMAP HDQ1W: use 32-bit register accesses
In-Reply-To: <20120123203638.GA8313@ioremap.net>
Message-ID: <alpine.DEB.2.00.1201240100420.29673@utopia.booyaka.com>
References: <alpine.DEB.2.00.1201221319270.26641@utopia.booyaka.com> <20120123150753.GA21395@ioremap.net> <alpine.DEB.2.00.1201231155590.29673@utopia.booyaka.com> <20120123203638.GA8313@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012, Evgeniy Polyakov wrote:

> On Mon, Jan 23, 2012 at 11:57:09AM -0700, Paul Walmsley (paul@pwsan.com) wrote:
> > http://www.spinics.net/lists/arm-kernel/msg156572.html
> 
> Well, if runtime PM does its job for clock manipulation properly, then
> things should be fine. I suppose that ->probe() will fire up first and
> you say it boots and detects w1 properly, so patch looks good.
> Feel free to add my ack

Thanks Evgeniy.

- Paul
