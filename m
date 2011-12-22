Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1LVS7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:59:19 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:37056 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1LVS7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:59:17 -0500
Date: Thu, 22 Dec 2011 13:59:11 -0500 (EST)
Message-Id: <20111222.135911.584309149966835644.davem@davemloft.net>
To: bhelgaas@google.com
Cc: James.Bottomley@hansenpartnership.com, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/29] Create PCI root buses with correct resources
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAErSpo7yoWOg8P1NAi70HJX=OMyO6XUwnUBxVq3P0YK87eP5tw@mail.gmail.com>
References: <CAErSpo7d3hHeJU87zYo=yJoG3eqOZ4QggkOyNnu7xuJe8oG9Qg@mail.gmail.com>
	<1318607132.3018.30.camel@dabdike.int.hansenpartnership.com>
	<CAErSpo7yoWOg8P1NAi70HJX=OMyO6XUwnUBxVq3P0YK87eP5tw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Dec 2011 10:59:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 20 Dec 2011 08:55:53 -0700

> This series has been in linux-next for a while now (via Jesse's PCI
> tree), so this would be a good time to try it out if you haven't
> already.
> 
> I know ia64 has been exercised a bit (thanks, Tony), but I haven't
> heard anything about arm, mips, parisc, powerpc, sparc, etc.
> 
> There is one outstanding bug fix for alpha that Jesse hasn't
> integrated yet, but as far as I know, everything else is in good
> shape.

I'll give it a quick test on sparc64 today.
