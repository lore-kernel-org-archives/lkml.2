Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab2JaQpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:45:07 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49951 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2JaQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:45:05 -0400
X-Auth-Info: sIwPE7NLPlc3rg3+UdYFurcaLTsmA+q9AiJ/oemau44=
From: Marek Vasut <marex@denx.de>
To: Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH for 3.7] mtd: nand: fix Samsung SLC NAND identification regression
Date: Wed, 31 Oct 2012 17:45:00 +0100
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Robin van der Gracht <robin@protonic.nl>
References: <1349850366-4731-1-git-send-email-computersforpeace@gmail.com> <1349855329.6072.72.camel@shinybook.infradead.org> <CAN8TOE8yzJY67b=S=KyONe2pLYGJVe9vW4KXzsjvU7AU9aFpHg@mail.gmail.com>
In-Reply-To: <CAN8TOE8yzJY67b=S=KyONe2pLYGJVe9vW4KXzsjvU7AU9aFpHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210311745.00677.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Brian Norris,

> Hi David,
> 
> On Wed, Oct 10, 2012 at 12:48 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> > On Tue, 2012-10-09 at 23:39 -0700, Brian Norris wrote:
> >> I can see if that's possible, but I think it's unlikely. They don't
> >> even bother following standards (ONFI). Is this an obstacle to
> >> merging?
> > 
> > No. I already pushed it.
> 
> This is a "bump" for a 3.7-rc pull request. This regression has been
> noticed by others.

[whine] my nand doesn't work ;-)

Thanks for keeping eye on this, Brian.

Best regards,
Marek Vasut
