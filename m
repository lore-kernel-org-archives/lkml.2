Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1ATS5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:57:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35865 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1ATS5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:57:09 -0500
Date: Thu, 20 Jan 2011 18:56:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110120185617.GI6335@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111031552.GJ3760@linux-sh.org> <4D3862DB.5000708@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3862DB.5000708@fluff.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 04:29:15PM +0000, Ben Dooks wrote:
> I really don't like the fact that people are doing these things in
> atomic contexts, and I think we should apply some pressure to move
> the atomic caller cases to use systems where they can sleep such as
> using threaded-irq handlers (they work very nicely)

How do you ensure that printk is always called from a non-atomic
context?
