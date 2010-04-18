Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab0DRJNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 05:13:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33950
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755277Ab0DRJNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 05:13:14 -0400
Date: Sun, 18 Apr 2010 02:13:18 -0700 (PDT)
Message-Id: <20100418.021318.169745594.davem@davemloft.net>
To: tj@kernel.org
Cc: tilman@imap.cc, isdn@linux-pingi.de, hjlipp@web.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gigaset: include cleanup cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BCA6B8E.9000408@kernel.org>
References: <20100416220858.A19F540123@xenon.ts.pxnet.com>
	<4BCA6B8E.9000408@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sun, 18 Apr 2010 11:16:46 +0900

> 
>> Seeing that the "include cleanup" patch triggering this was accepted
>> after the merge window, I have hopes this one will be accepted, too.
> 
> Hmm... through which tree should this go through?  I can route it
> through percpu but maybe taking the usual isdn patch path would be
> better?

I'll take it into net-2.6, no worries.
