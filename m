Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0DEVvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:51:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59598
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756439Ab0DEVvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:51:42 -0400
Date: Mon, 05 Apr 2010 14:51:44 -0700 (PDT)
Message-Id: <20100405.145144.207421561.davem@davemloft.net>
To: joe@perches.com
Cc: akpm@linux-foundation.org, david.vrabel@csr.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] drivers/uwb: Rename dev_info to wdi
From: David Miller <davem@davemloft.net>
In-Reply-To: <1270503858.31062.43.camel@Joe-Laptop.home>
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
	<6bd4d4dacf32631b72c3827a3b133a26e2e8b889.1270493677.git.joe@perches.com>
	<1270503858.31062.43.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 05 Apr 2010 14:44:18 -0700

> On Mon, 2010-04-05 at 12:05 -0700, Joe Perches wrote:
>> There is a macro called dev_info that prints struct device specific
>> information.  Having variables with the same name can be confusing and
>> prevents conversion of the macro to a function.
>> 
>> Rename the existing dev_info variables to something else in preparation
>> to converting the dev_info macro to a function.
> 
> http://patchwork.ozlabs.org/patch/49421/
> 
> This marked as RFC in patchwork.
> It's not intended to be.

Because I can't apply the entire set, I'd like someone else
to take this in since it's not really a networking specific
patch.
