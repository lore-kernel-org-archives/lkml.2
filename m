Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0IQXvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:51:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55523
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab0IQXvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:51:02 -0400
Date: Fri, 17 Sep 2010 16:51:20 -0700 (PDT)
Message-Id: <20100917.165120.139548355.davem@davemloft.net>
To: aaw@google.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org, davem@google.com
Subject: Re: [PATCH] Move "struct net" declaration inside the __KERNEL__
 macro guard
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimRSjqewc_mC5vwdXy1t4Ax5rAf5svpOTbUEF7o@mail.gmail.com>
References: <AANLkTimXnjnkNgwtEVpXKYMxXgmBdye=Gtjeggd4N9UA@mail.gmail.com>
	<AANLkTimRSjqewc_mC5vwdXy1t4Ax5rAf5svpOTbUEF7o@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ollie Wild <aaw@google.com>
Date: Fri, 17 Sep 2010 14:38:59 -0500

> (Resending with a proper signoff.)

Your patch is still unusable because your email client white-space mangled
the patch, turning tabs into space characters.

Please fix this up and resubmit, thanks.
