Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1IPXV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 19:21:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58942 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1IPXVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 19:21:55 -0400
Date: Fri, 16 Sep 2011 19:21:49 -0400 (EDT)
Message-Id: <20110916.192149.1065047590139083586.davem@davemloft.net>
To: wg@grandegger.com
Cc: zonque@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: ti_hecc: include linux/io.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E73A123.1040801@grandegger.com>
References: <1316195863-18695-1-git-send-email-zonque@gmail.com>
	<4E73A123.1040801@grandegger.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 16 Sep 2011 16:21:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Fri, 16 Sep 2011 21:18:59 +0200

> On 09/16/2011 07:57 PM, Daniel Mack wrote:
>> This fixes a build breakage for OMAP3 boards.
>> 
>> Signed-off-by: Daniel Mack <zonque@gmail.com>
>> Cc: Wolfgang Grandegger <wg@grandegger.com>
>> Cc: netdev@vger.kernel.org
> 
> Acked-by: Wolfgang Grandegger <wg@grandegger.com>

Applied.
