Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050Ab2FATiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:38:20 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:59526 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865Ab2FATiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:38:18 -0400
Date: Fri, 1 Jun 2012 21:29:44 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Miller <davem@davemloft.net>
Cc: devendra.aaru@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: call netif_napi_del at errpaths and at driver unload
Message-ID: <20120601192944.GA21881@electric-eye.fr.zoreil.com>
References: <1338465080-22720-1-git-send-email-devendra.aaru@gmail.com> <20120601.142531.544977894901194434.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601.142531.544977894901194434.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> :
[...]
> Francois, I'm assuming you will merge this to me after you've
> done some testing.

You can apply it directly.

I have done several loops both with a forced error patch and the normal
removal of the module without problem. No trivial crash. Four 816x network
adapters. Reference one still comes up.

-- 
Ueimor
