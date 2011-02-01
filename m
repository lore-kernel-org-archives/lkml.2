Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1BAT5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:57:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43852 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1BAT5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:57:51 -0500
Date: Tue, 1 Feb 2011 19:56:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110201195604.GS31216@n2100.arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110201105449.GY1147@pengutronix.de> <20110201131512.GH31216@n2100.arm.linux.org.uk> <20110201141837.GA1147@pengutronix.de> <20110201143932.GK31216@n2100.arm.linux.org.uk> <20110201151846.GD1147@pengutronix.de> <20110201152458.GP31216@n2100.arm.linux.org.uk> <20110201155344.GF1147@pengutronix.de> <20110201170637.GR31216@n2100.arm.linux.org.uk> <20110201193201.GH1147@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201193201.GH1147@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 08:32:01PM +0100, Uwe Kleine-König wrote:
> On Tue, Feb 01, 2011 at 05:06:37PM +0000, Russell King - ARM Linux wrote:
> > So?  You're not _supposed_ to call it from any atomic context ever.
>
> My motivation for a more complicated clk_prepare was to make clk_prepare
> atomic when that's possible (i.e. when the clk is already prepared) and
> call it before the enable callback in clk_enable.  Then everything
> behaves nicely even if clk_enable is called from atomic context provided
> that the clock was prepared before (or doesn't need to).

You really don't get the point of clk_prepare() do you.  I'm not
going to bother trying to educate you anymore.

Hopefully someone with more patience can give you the necessary
teaching to make you understand.
