Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0LJTJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:09:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50460
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756210Ab0LJTJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:09:19 -0500
Date: Fri, 10 Dec 2010 11:09:46 -0800 (PST)
Message-Id: <20101210.110946.260074147.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: rjw@sisk.pl, mjg@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH, post-2.6.36 regression fix] r8169: Fix runtime power
 management
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101209092804.GA4113@electric-eye.fr.zoreil.com>
References: <201012090232.14375.rjw@sisk.pl>
	<20101209092804.GA4113@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Thu, 9 Dec 2010 10:28:04 +0100

> Rafael J. Wysocki <rjw@sisk.pl> :
> [...]
>> I noticed that one of the post-2.6.36 patches broke runtime PM of the
>> r8169 on my MSI Wind test machine in such a way that the link was not
>> brought up after reconnecting the network cable.
>> 
>> In the process of debugging the issue I realized that we only should
>> invoke the runtime PM functions in rtl8169_check_link_status() when
>> link change is reported and if we do so, the problem goes away.
>> Moreover, this allows rtl8169_runtime_idle() to be simplified quite
>> a bit.
>> 
>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Acked-by: Francois Romieu <romieu@fr.zoreil.com>

Applied, thanks.
