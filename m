Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1EPPV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:21:57 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35843 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755769Ab1EPPV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:21:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fjv2D7Ts3fz5xcBrCubIVv4Lo9MQZCPUYx7aTwOKl9Wg/kXcquS3lWHjlLjAFcJhsZWR9IUGaoXFGGr2ey2v9VxEsRgnLb8jVvkgGDD3dm+FjYS6eTO8cHbe/rYcraYp;
Date: Mon, 16 May 2011 08:21:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value in centralizing a defn of "RUN_AT()"?
Message-Id: <20110516082153.b55d3f85.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.00.1105151616530.28104@localhost6.localdomain6>
References: <alpine.DEB.2.00.1105151616530.28104@localhost6.localdomain6>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 May 2011 16:18:17 -0400 (EDT) Robert P. J. Day wrote:

> 
>   i notice that a number of drivers duplicate a macro definition of
> RUN_AT():
> 
> drivers/staging/vt6655/device.h:#define RUN_AT(x) (jiffies+(x))
> drivers/net/irda/au1k_ir.c:#define RUN_AT(x) (jiffies + (x))
> drivers/net/hamachi.c:#define RUN_AT(x) (jiffies + (x))
> drivers/net/tulip/tulip.h:#define RUN_AT(x) (jiffies + (x))
> drivers/net/wireless/airo.c:#define RUN_AT(x) (jiffies+(x))
> drivers/net/rrunner.c:#define RUN_AT(x) (jiffies + (x))
> drivers/net/bnx2.c:#define RUN_AT(x) (jiffies + (x))
> drivers/net/3c59x.c:#define RUN_AT(x) (jiffies + (x))
> drivers/net/fealnx.c:#define RUN_AT(x) (jiffies + (x))
> 
>   etc, etc.  any value in just defining that once in jiffies.h and
> letting everyone use that?

Yes IMO.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
