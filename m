Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0HHGOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 02:14:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63922 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab0HHGOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 02:14:43 -0400
MIME-Version: 1.0
In-Reply-To: <20100807.225629.90779399.davem@davemloft.net>
References: <20100807.225009.43057146.davem@davemloft.net> 
	<20100807.225629.90779399.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 8 Aug 2010 00:14:23 -0600
X-Google-Sender-Auth: tNzjpyLXT16KPRiWe6s1HUxMgA8
Message-ID: <AANLkTikXQ+SduYPZo1DcVH+T7+Od_vkf0CdcWSkp100V@mail.gmail.com>
Subject: Re: OF change bustage...
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 11:56 PM, David Miller <davem@davemloft.net> wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sat, 07 Aug 2010 22:50:09 -0700 (PDT)
>
>> drivers/crypto/n2_core.c: In function 'find_devino_index':
>> drivers/crypto/n2_core.c:1583:21: error: 'struct platform_device' has no member named 'num_irqs'
>> drivers/crypto/n2_core.c: In function 'spu_map_ino':
>> drivers/crypto/n2_core.c:1606:14: error: 'struct platform_device' has no member named 'irqs'
>>
>> Looks simply like missing "archdata." prefixes.
>
> Same problem in drivers/net/greth.c

Yup in both cases.  I missed fixing them up in commit
1636f8ac2b08410df4766449f7c86b912443cd99.  I'm test-building a patch
right now.

g.
