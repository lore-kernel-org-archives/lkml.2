Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882Ab1DNEBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 00:01:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52393
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab1DNEBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 00:01:05 -0400
Date: Wed, 13 Apr 2011 21:00:29 -0700 (PDT)
Message-Id: <20110413.210029.104051971.davem@davemloft.net>
To: michaele@au1.ibm.com
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org,
        tony@bakeyournoodle.com
Subject: Re: Build regressions/improvements in v2.6.39-rc3
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302744378.12513.84.camel@concordia>
References: <BANLkTinT09RGg5XDUGy76Kpa8yX3DNUoQw@mail.gmail.com>
	<1302739533.12513.32.camel@concordia>
	<1302744378.12513.84.camel@concordia>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michaele@au1.ibm.com>
Date: Thu, 14 Apr 2011 11:26:17 +1000

> So allmodconfig enables CONFIG_BUILD_DOCSRC, which builds the code in
> Documentation, which is userspace code.
> 
> In our case we know that won't work because our cross tool chain doesn't
> have libc, so I've taught kisskb to disable CONFIG_BUILD_DOCSRC for
> allmodconfig builds.

Great, thanks for looking into this.
