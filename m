Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1GYXUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:20:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46743 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1GYXUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:20:36 -0400
Date: Mon, 25 Jul 2011 16:16:32 -0700 (PDT)
Message-Id: <20110725.161632.432205077107811689.davem@davemloft.net>
To: schaman@sch.bme.hu
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] IPv4: Send gratuitous ARP for secondary IP
 addresses also
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311548970-27522-1-git-send-email-schaman@sch.bme.hu>
References: <1311548970-27522-1-git-send-email-schaman@sch.bme.hu>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 25 Jul 2011 16:16:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Zoltan, Kiss" <schaman@sch.bme.hu>
Date: Mon, 25 Jul 2011 01:09:30 +0200

> From: Zoltan Kiss <schaman@sch.bme.hu>
> 
> If a device event generates gratuitous ARP messages, only primary
> address is used for sending. This patch iterates through the whole
> list. Tested with 2 IP addresses configuration on bonding interface.
> 
> Signed-off-by: Zoltan Kiss <schaman@sch.bme.hu>

Applied.
