Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1CGCHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:07:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39863
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab1CGCHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:07:21 -0500
Date: Sun, 06 Mar 2011 18:07:58 -0800 (PST)
Message-Id: <20110306.180758.226774711.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: rdunlap@xenotime.net, j223yang@asset.uwaterloo.ca, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch] ariadne: fix possible null dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTiko+HzYMnGEtvb63Fzi2eNge6_iWPmk7EfjFma7@mail.gmail.com>
References: <20110306070832.GA26188@asset.uwaterloo.ca>
	<20110306111141.9cc51306.rdunlap@xenotime.net>
	<AANLkTiko+HzYMnGEtvb63Fzi2eNge6_iWPmk7EfjFma7@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 6 Mar 2011 21:00:13 +0100

> On Sun, Mar 6, 2011 at 20:11, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On Sun, 6 Mar 2011 02:08:32 -0500 j223yang@asset.uwaterloo.ca wrote:
>>
>>> Hi Randy,
>>> I have tested my patch, and it is ok now.
>>> Could you please try patching again? Sorry for previous trouble.
>>> Thank you!
>>
>> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

People really don't actually read patches, I think.

Show me how dev can even be NULL here, it simply can't.

So the correct fix is to remove the dev==NULL check altogether.
