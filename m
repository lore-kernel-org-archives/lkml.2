Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965922Ab2FAWpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:45:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45186 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965841Ab2FAWo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:44:58 -0400
Date: Fri, 01 Jun 2012 18:44:57 -0400 (EDT)
Message-Id: <20120601.184457.312806072581031622.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: devendra.aaru@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: call netif_napi_del at errpaths and at driver
 unload
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120601192944.GA21881@electric-eye.fr.zoreil.com>
References: <1338465080-22720-1-git-send-email-devendra.aaru@gmail.com>
	<20120601.142531.544977894901194434.davem@davemloft.net>
	<20120601192944.GA21881@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Fri, 1 Jun 2012 21:29:44 +0200

> David Miller <davem@davemloft.net> :
> [...]
>> Francois, I'm assuming you will merge this to me after you've
>> done some testing.
> 
> You can apply it directly.
> 
> I have done several loops both with a forced error patch and the normal
> removal of the module without problem. No trivial crash. Four 816x network
> adapters. Reference one still comes up.

Ok, applied, thanks.
