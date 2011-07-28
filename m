Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1G1Nmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:42:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1G1Nms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:42:48 -0400
Date: Thu, 28 Jul 2011 06:42:45 -0700 (PDT)
Message-Id: <20110728.064245.1432029423461356975.davem@davemloft.net>
To: maciej.rutecki@gmail.com
Cc: w41ter@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [bisected regression] Partial breakage of forcedeth driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <201107281541.09069.maciej.rutecki@gmail.com>
References: <4E2CA683.4010005@gmail.com>
	<201107281541.09069.maciej.rutecki@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 28 Jul 2011 06:42:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Rutecki <maciej.rutecki@gmail.com>
Date: Thu, 28 Jul 2011 15:41:08 +0200

> On poniedzia©©ek, 25 lipca 2011 o 01:10:59 walt wrote:
>> Hi gang.
>> 
>> commit 3326c784c9f492e988617d93f647ae0cfd4c8d09
>> Author: Jiri Pirko <jpirko@>
>> Date:   Wed Jul 20 04:54:38 2011 +0000
>> 
>>     forcedeth: do vlan cleanup
>> 
>>     - unify vlan and nonvlan rx path
>>     - kill np->vlangrp and nv_vlan_rx_register
>>     - allow to turn on/off rx vlan accel via ethtool (set_features)
>> 
>>     Signed-off-by: Jiri Pirko <jpirko@>
>>     Signed-off-by: David S. Miller <davem@>
>> 
>> This commit causes networking trouble for my nForce-based motherboard.
>> (Details happily supplied if needed.)
>> 
> 
> [...]
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=40272
> for your bug report, please add your address to the CC list in there, thanks!

It's fixed already in Linus's tree as of a few minuts ago.
