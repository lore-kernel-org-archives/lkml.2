Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab1CRWPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:15:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43749
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932338Ab1CRWOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:14:54 -0400
Date: Fri, 18 Mar 2011 15:15:32 -0700 (PDT)
Message-Id: <20110318.151532.52204604.davem@davemloft.net>
To: philb@gnu.org
Cc: segoon@openwall.com, linux-kernel@vger.kernel.org, security@kernel.org,
        eric.dumazet@gmail.com, tj@kernel.org, nelhage@ksplice.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] econet: 4 byte infoleak to the network
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300362601.2132.14721.camel@phil-desktop>
References: <1300362011-8653-1-git-send-email-segoon@openwall.com>
	<1300362601.2132.14721.camel@phil-desktop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Blundell <philb@gnu.org>
Date: Thu, 17 Mar 2011 11:50:01 +0000

> On Thu, 2011-03-17 at 14:40 +0300, Vasiliy Kulikov wrote:
>> struct aunhdr has 4 padding bytes between 'pad' and 'handle' fields on
>> x86_64.  These bytes are not initialized in the variable 'ah' before
>> sending 'ah' to the network.  This leads to 4 bytes kernel stack
>> infoleak.
>> 
>> This bug was introduced before the git epoch.
>> 
>> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> 
> Well spotted.  Thanks for the patch.
> 
> Acked-by: Phil Blundell <philb@gnu.org>

Applied.
