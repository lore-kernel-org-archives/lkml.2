Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab2KVUcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:32:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36611 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2KVUbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:31:11 -0500
Date: Thu, 22 Nov 2012 15:31:09 -0500 (EST)
Message-Id: <20121122.153109.5858248905090876.davem@davemloft.net>
To: xemul@parallels.com
Cc: avagin@openvz.org, netdev@vger.kernel.org, criu@openvz.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] ipv6: adapt connect for repair move
From: David Miller <davem@davemloft.net>
In-Reply-To: <50AE11BA.4030803@parallels.com>
References: <1353582838-18876-1-git-send-email-avagin@openvz.org>
	<50AE11BA.4030803@parallels.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@parallels.com>
Date: Thu, 22 Nov 2012 15:51:22 +0400

> On 11/22/2012 03:13 PM, Andrey Vagin wrote:
>> This is work the same as for ipv4.
>> 
>> All other hacks about tcp repair are in common code for ipv4 and ipv6,
>> so this patch is enough for repairing ipv6 connections.
>> 
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>> Cc: Patrick McHardy <kaber@trash.net>
>> Cc: Pavel Emelyanov <xemul@parallels.com>
>> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> 
> Acked-by: Pavel Emelyanov <xemul@parallels.com>

Applied, thanks.
