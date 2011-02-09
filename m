Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1BIWAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:00:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39834
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab1BIWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:00:40 -0500
Date: Wed, 09 Feb 2011 14:01:15 -0800 (PST)
Message-Id: <20110209.140115.183045242.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.38-rc4 (other bugs)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110209093656.2b23b80b.randy.dunlap@oracle.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<20110209093656.2b23b80b.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 9 Feb 2011 09:36:56 -0800

> 
> There are also bugs or other oopses etc. with ipmi, x25 (rmmod hangs system),
> and (usb gadget) g_audio, but I don't have logs for them yet...
> Someone else could do those.

Randy if you could simply get a CPU program counter when the x25
rmmod hang happens, I can probably fix it quickly.

But if you don't have time I can fiddle around with it myself.
