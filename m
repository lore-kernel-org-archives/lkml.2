Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2IMJ1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:27:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60391 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2IMJ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6FEE@saturn3.aculab.com>
References: <1347462407-13499-9-git-send-email-peter.senna@gmail.com>
	<AE90C24D6B3A694183C094C60CF0A2F6026B6FEE@saturn3.aculab.com>
Date: Thu, 13 Sep 2012 11:27:49 +0200
Message-ID: <CA+MoWDqiudaBC=sLUuQABTZHp2yUTVB+RY73no8s61fsG7vaZQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] drivers/isdn/gigaset/common.c: Remove useless kfree
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: David Laight <David.Laight@aculab.com>
Cc: Hansjoerg Lipp <hjlipp@web.de>, kernel-janitors@vger.kernel.org,
        Tilman Schmidt <tilman@imap.cc>, Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems to me that (assuming kfree(NULL) is ok) the kfree()
> is best left in - just in case some other error path is
> added after drv->cs is assigned.
> Better safe than a memory leak.

I'm not sure if I got your point. Now the label "error:" is only
reached if drv->cs is NULL. There is not other way to move to error:
unless drv->cs is NULL. Why wouldn't be safe to remove the
kfree(drv->cs) when drv->cs is NULL?


-- 
Peter
