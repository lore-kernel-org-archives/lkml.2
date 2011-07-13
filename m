Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965341Ab1GMLM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:12:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48272 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965255Ab1GMLM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:12:58 -0400
Date: Wed, 13 Jul 2011 04:12:53 -0700 (PDT)
Message-Id: <20110713.041253.1879038886370324446.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: arend@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: change return values in mac_pton() function
From: David Miller <davem@davemloft.net>
In-Reply-To: <CACVxJT-TXBd5S+HNfzNR2hnGUk2hMfTSQrkodUunUXOQ6+X8eg@mail.gmail.com>
References: <1310549424-5484-1-git-send-email-arend@broadcom.com>
	<CACVxJT-TXBd5S+HNfzNR2hnGUk2hMfTSQrkodUunUXOQ6+X8eg@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 13 Jul 2011 04:12:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Wed, 13 Jul 2011 13:09:03 +0300

> On Wed, Jul 13, 2011 at 12:30 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> The original commit adding this function noted a diverge from usual
>> 0=success/-E=fail, but no motivation for it.
> 
> I thought it was obvious, but indeed wasn't explicitely
> mentioned in changelog. But see inet_pton(3).

Agreed it's better for mac_pton() to be consistent with existing,
similar, interfaces like inet_pton.
