Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab0LQHB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 02:01:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:49919 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750858Ab0LQHBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 02:01:25 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19ulTcpc7RufccXTlaMQV4A5gqTuk3DF0FT8+m5TN
	2PSMEHd/XQjWZu
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Nick Piggin <npiggin@kernel.dk>
Subject: Re: include/linux: Add missing include / fix build failure
Date: Fri, 17 Dec 2010 08:01:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.4.5; x86_64; ; )
Cc: Axel <axel.lin@gmail.com>, "linux-kernel" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
References: <g06LM-1y8-17@gated-at.bofh.it> <0d7b441c-a702-4bce-8711-8c0cedfb5d8a@c17g2000prm.googlegroups.com> <20101217052642.GA3282@amd>
In-Reply-To: <20101217052642.GA3282@amd>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012170801.22323.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > After apply the patch,
> > I got below error message while
> > # make i386_defconfig;make

Sorry about that - thanks for testing!

> > I personally fix it by below patch now, but I'm not so sure if this is
> > a good way to fix it.

> Yes it should be fixed in arm code. If someone would send along a
> patch to the maintainer, that would be appreciated.

Axel seems to have done that already - unfortunately I haven't found the time 
yesterday. Thanks!


I'll review/test the patch tonight - meanwhile you'll get a
Reported-by: Peter Huewe <peterhuewe@gmx.de>

Thanks,
Peter
