Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1AORo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 12:44:26 -0500
Received: from 51.197.216.81.static.s-h.siw.siwnet.net ([81.216.197.51]:46098
	"EHLO sloth.weinigel.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753049Ab1AORoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 12:44:25 -0500
Message-ID: <4D31DCF6.7090805@weinigel.se>
Date: Sat, 15 Jan 2011 18:44:22 +0100
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <4D2D184A.8020405@codeaurora.org> <20110112090301.GS11039@n2100.arm.linux.org.uk> <4D31A8F1.4080301@weinigel.se> <20110115145358.GC15996@n2100.arm.linux.org.uk> <4D31D45A.8080509@weinigel.se> <20110115172033.GM15996@n2100.arm.linux.org.uk>
In-Reply-To: <20110115172033.GM15996@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2011 06:20 PM, Russell King - ARM Linux wrote:
 > You really need to read the entire thread - I've already said that yet

> discussion continues about how to solve the problem.  This thread which
> has been running for a number of days now has been entirely about how
> to solve this.


Sigh, the always oh so polite Russell.  I have read the thread before; I 
reread the whole thread one more time before posting.

> Consider this: is it better to continue talking about this for the next
> six months, while still having N spinlock based implementations, and M
> mutex based implementations.
>
> Or is it better to consolidate the N spinlock based implementations
> down to one spinlock implementation, and M mutex based implementations
> down to one mutex implementation, and then discuss how to resolve the
> differences between the two implementations?


Going that way might very well mean that you will be stuck with two 
implementations forever.  But yes, it might be better with two working 
ones than one which takes a bit longer to finish.

But my impression is that the different suggestions in the thread aren't 
that far apart.  Except for the discussion if clk_enable/disable should 
be able to sleep or not, people seem to agree on most of the rest of the 
API.

   /Christer
