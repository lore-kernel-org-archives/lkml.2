Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1K2GUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:20:45 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:34923 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab1K2GUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:20:41 -0500
Date: Tue, 29 Nov 2011 01:17:00 -0500 (EST)
Message-Id: <20111129.011700.785105982911525415.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: axel.lin@gmail.com, linux-kernel@vger.kernel.org, wg@grandegger.com,
        bhupesh.sharma@st.com, jkosina@suse.cz, grant.likely@secretlab.ca,
        agust@denx.de, pebolle@tiscali.nl, kurt.van.dijck@eia.be,
        adobriyan@gmail.com, linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/can: convert drivers/net/can/* to use
 module_platform_driver()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ED35FC4.3040007@pengutronix.de>
References: <1322444551.2408.2.camel@phoenix>
	<4ED35FC4.3040007@pengutronix.de>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 28 Nov 2011 22:17:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Mon, 28 Nov 2011 11:17:40 +0100

> On 11/28/2011 02:42 AM, Axel Lin wrote:
>> This patch converts the drivers in drivers/net/can/* to use the
>> module_platform_driver() macro which makes the code smaller and a bit
>> simpler.
>> 
>> Cc: Wolfgang Grandegger <wg@grandegger.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Bhupesh Sharma <bhupesh.sharma@st.com> 
>> Cc: Jiri Kosina <jkosina@suse.cz>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Anatolij Gustschin <agust@denx.de> 
>> Cc: Paul Bolle <pebolle@tiscali.nl>
>> Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>
>> Cc: Alexey Dobriyan <adobriyan@gmail.com> 
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

Applied.
