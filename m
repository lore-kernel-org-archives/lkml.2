Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1DJU25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 16:28:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47960
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab1DJU2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 16:28:53 -0400
Date: Sun, 10 Apr 2011 13:28:17 -0700 (PDT)
Message-Id: <20110410.132817.226768042.davem@davemloft.net>
To: buytenh@wantstofly.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove non-MAINTAINERS email address references for
 Lennert Buytenhek.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110410202716.GK22881@wantstofly.org>
References: <20110410134504.GG22881@wantstofly.org>
	<20110410.132002.193717670.davem@davemloft.net>
	<20110410202716.GK22881@wantstofly.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lennert Buytenhek <buytenh@wantstofly.org>
Date: Sun, 10 Apr 2011 22:27:16 +0200

> The problem is that half of them are out of date.  I at first sent a
> patch to change them all over to buytenh@wantstofly.org, but then got:
> 
> 	http://marc.info/?l=linux-kernel&m=129858453409012&w=2
> 
> which seemed sensible. :-/

It's not just about maintainership, it's about copyright too.

For example, whether someone does or does not use their employer's
email address in the copyright can have an impact on whether their
employer can make a claim on copyright of the work.  There
are therefore real implications for what email address is there.

Like Andrew said, if people want to reach the active maintainer
they can use MAINTAINERS or look into the recent GIT logs for
the associated files.

Changing copyright email addresses can get into unrelated areas.
