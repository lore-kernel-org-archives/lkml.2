Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1DNEVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 00:21:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59840 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1DNEVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 00:21:14 -0400
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>
In-Reply-To: <1299134429.100626.661279191478.0.gpush@pororo>
References: <1299134429.100626.661279191478.0.gpush@pororo>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 12:20:59 +0800
Message-ID: <1302754859.2767.30.camel@pororo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Any updates on these patches? I've added to your patch-tracker, would
you expect these to make the next merge window, or are there changes
you'd like made first?

Reason I ask is that I have a few queries from platform maintainers that
would like to complete their clock ports to this API, but don't want to
commit until the interface has been accepted, in at least an initial
form.

Cheers,


Jeremy

