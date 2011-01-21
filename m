Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1AUJbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:31:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51639 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1AUJbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:31:44 -0500
Date: Fri, 21 Jan 2011 09:31:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Ben Dooks <ben-linux@fluff.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110121093104.GA13235@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111031552.GJ3760@linux-sh.org> <201101111211.30172.jeremy.kerr@canonical.com> <20110111045423.GP3760@linux-sh.org> <4D3863AC.4020209@fluff.org> <20110120185707.GJ6335@n2100.arm.linux.org.uk> <4D3900DB.8090401@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3900DB.8090401@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 07:43:23PM -0800, Saravana Kannan wrote:
> On 01/20/2011 10:57 AM, Russell King - ARM Linux wrote:
>> On Thu, Jan 20, 2011 at 04:32:44PM +0000, Ben Dooks wrote:
>>> I would vote for all clk lookup and reference counting code be made
>>> sleep-able and define it as such.
>>
>> Always has been and probably always will be.
>>
>
> clk_enable/disable APIs have refcounting and they certainly aren't  
> sleep-able. I'm not sure if that's what Ben meant though.

Ben's talking about clk_get/clk_put.  See "clk lookup" in his sentence.
