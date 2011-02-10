Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1BJDRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:17:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47307
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755024Ab1BJDRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:17:17 -0500
Date: Wed, 09 Feb 2011 19:17:52 -0800 (PST)
Message-Id: <20110209.191752.226762899.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: jiaweiwei.xiyou@gmail.com, linux-kernel@vger.kernel.org, joe@perches.com,
        greg@kroah.com, rdunlap@xenotime.net
Subject: Re: [PATCH]move double quotation marks so that keep MAINTAINERS
 consistent
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110209190631.f29419ef.akpm@linux-foundation.org>
References: <20110210025133.GA3285@gmail.com>
	<20110209190631.f29419ef.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 9 Feb 2011 19:06:31 -0800

> I suspect that some mail clients will explode if you provide them with
> an unquoted string containing periods.  That would make copy-n-paste
> rather a hassle.

It's not clients, it's servers.

SMTP rules state that characters such as "." cannot appear
unquoted in email headers.

vger.kernel.org rejects mail when this violation occurs.
