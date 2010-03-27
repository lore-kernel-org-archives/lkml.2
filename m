Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0C0OoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 10:44:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50618
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931Ab0C0OoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 10:44:12 -0400
Date: Sat, 27 Mar 2010 07:44:34 -0700 (PDT)
Message-Id: <20100327.074434.193717071.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: david@fries.net, jeff@garzik.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.34-rc2 breaks via82cxxx Host Protected Area
From: David Miller <davem@davemloft.net>
In-Reply-To: <201003271119.53757.bzolnier@gmail.com>
References: <4BAD5472.9050303@garzik.org>
	<20100327020934.GA8224@spacedout.fries.net>
	<201003271119.53757.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Sat, 27 Mar 2010 11:19:53 +0100

> The commit itself may also have a problem but since it was _never_ in
> linux-next tree it never saw a wider upstream testing.

This is not true Bart.

My ide-2.6 and ide-next-2.6 trees are both included in
linux-next   And if they are not, that needs to be fixed
because they very much are intended to be.

In any event, you wrote a patch which broke something and
if you're not willing to work on a fix I have no choice
but to simply revert.
