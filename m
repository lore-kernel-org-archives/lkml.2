Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2AXUaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:30:11 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41640 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2AXUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:30:09 -0500
Date: Tue, 24 Jan 2012 15:29:52 -0500 (EST)
Message-Id: <20120124.152952.59640686729726715.davem@davemloft.net>
To: florian@openwrt.org
Cc: rubini@gnudd.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        giancarlo.asnaghi@st.com, peppe.cavallaro@st.com
Subject: Re: stmmac: fix phy naming inconsistency
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F1E90B6.6090106@openwrt.org>
References: <20120124092648.GA26380@mail.gnudd.com>
	<4F1E90B6.6090106@openwrt.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 Jan 2012 12:29:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>
Date: Tue, 24 Jan 2012 12:06:30 +0100

> Hello Alessandro,
> 
> On 01/24/12 10:26, Alessandro Rubini wrote:
>> After commit "db8857b stmmac: use an unique MDIO bus name" my
>> device stopped being probed because two different names were being
>> used in different places. This fixes the inconsistency.
>>
>> Signed-off-by: Alessandro Rubini<rubini@gnudd.com>
>> Acked-by: Giancarlo Asnaghi<giancarlo.asnaghi@st.com>
>> Cc: Giuseppe Cavallaro<peppe.cavallaro@st.com>
>> Cc: Florian Fainelli<florian@openwrt.org>
> 
> Acked-by: Florian Fainelli <florian@openwrt.org>

Applied, thanks.
