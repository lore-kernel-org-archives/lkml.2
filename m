Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1BNGOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 01:14:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50130 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750911Ab1BNGOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 01:14:34 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+IuNIbEuaI1P6ogHuZ8rDPGb4Xy9lNDX9VNqkEll
	HDrY0Hi+Nc/8dv
Subject: Re: Kernel debugging method
From: Mike Galbraith <efault@gmx.de>
To: Amirali Shambayati <amirali.shambayati@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTik1jWPn2QRCWz4r43WzD7rgH7Gn=HMOKdatNj=p@mail.gmail.com>
References: <AANLkTik1jWPn2QRCWz4r43WzD7rgH7Gn=HMOKdatNj=p@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 07:14:30 +0100
Message-ID: <1297664070.7999.65.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-13 at 13:56 +0330, Amirali Shambayati wrote:
> Hello all,
> 
> Can anybody show me a method for kernel debugging? I just want to
> modify one file(Noop IO scheduler).

I recommend the most powerful, and easiest to use, kernel debugger known
to man: printk :)

	-Mike

