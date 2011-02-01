Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1BAUg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:36:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33126 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1BAUg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:36:58 -0500
Date: Tue, 1 Feb 2011 20:36:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110201203625.GT31216@n2100.arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110201105449.GY1147@pengutronix.de> <20110201131512.GH31216@n2100.arm.linux.org.uk> <20110201141837.GA1147@pengutronix.de> <20110201143932.GK31216@n2100.arm.linux.org.uk> <20110201151846.GD1147@pengutronix.de> <20110201152458.GP31216@n2100.arm.linux.org.uk> <4D486E08.9000709@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D486E08.9000709@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 12:33:12PM -0800, Saravana Kannan wrote:
> Looks like this is the best acknowledgment/response I can expect to get  
> from Russell on this point that I raised.

Sorry, I've been up to my eyeballs with other stuff over the last few
weeks.  Yes, I think clk_set_rate() needs to be sleep-able too.
