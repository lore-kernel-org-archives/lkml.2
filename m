Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030652Ab2B2C3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 21:29:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51985 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab2B2C3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:29:02 -0500
Date: Tue, 28 Feb 2012 21:28:57 -0500 (EST)
Message-Id: <20120228.212857.797446903975232476.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: rodrigue@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca-linux-team@qualcomm.com,
        nic-devel@qualcomm.com, kgiori@qca.qualcomm.com, chris.snook@gmail.com,
        mathieu@qca.qualcomm.com, bryanh@quicinc.com
Subject: Re: [PATCH] net: add QCA alx Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <157393863283F442885425D2C4542856194154FC@nasanexd02a.na.qualcomm.com>
References: <20120228.205347.1718771650331094141.davem@davemloft.net>
	<CAB=NE6VXyQ-k1Sm3Xf_ABE35+PHSoNqX=AJpLBjNu0sdAdnY4g@mail.gmail.com>
	<157393863283F442885425D2C4542856194154FC@nasanexd02a.na.qualcomm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 18:28:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Huang, Xiong" <xiong@qca.qualcomm.com>
Date: Wed, 29 Feb 2012 02:19:05 +0000

>      The code related to hardware of atl1c is quite diff with that
> in our hand, every time we take much time to find which part should
> be revised for one bug/issue found on other platform/OSes. the new
> driver make it easy to fix and support new chipset as well.

Broadcom gave the same excuses.  Save yourself some typing.

I already know what you are going to say and claim are the issues.

I've heard it all before, and none of them justify replacing the
existing driver wholesale.  We simply don't operate this way.

Because you guys didn't upstream your driver properly back when
the atl1c hardware first came out and Linux needed a driver,
someone else did.

And we're not removing their driver just because now you guys just
want to come in and take over simply because you're not willing to
collaborate properly and contribute to the existing code like everyone
else on the planet does.

There is no arguing against this, there is no justification, and it
simply will not happen.  I'm sorry you put some must effort into this
but you should have been smart and listened to Luis last year when he
tried to guide you in the right direction.

Listening to Luis would have saved you a lot of wasted engineering.

Maybe you will be smart and listen to him next time.
