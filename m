Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935821Ab2JaQUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:20:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33616 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944Ab2JaQUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <1349855329.6072.72.camel@shinybook.infradead.org>
References: <1349850366-4731-1-git-send-email-computersforpeace@gmail.com>
	<1349850682.6072.70.camel@shinybook.infradead.org>
	<CAN8TOE-ZLyCanBx8pqsbzY6jMQq+ysiVvdLmWvO8QdnyZg1QRg@mail.gmail.com>
	<1349855329.6072.72.camel@shinybook.infradead.org>
Date: Wed, 31 Oct 2012 09:20:01 -0700
Message-ID: <CAN8TOE8yzJY67b=S=KyONe2pLYGJVe9vW4KXzsjvU7AU9aFpHg@mail.gmail.com>
Subject: Re: [PATCH for 3.7] mtd: nand: fix Samsung SLC NAND identification regression
From: Brian Norris <computersforpeace@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, Marek Vasut <marex@denx.de>,
        Robin van der Gracht <robin@protonic.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Oct 10, 2012 at 12:48 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Tue, 2012-10-09 at 23:39 -0700, Brian Norris wrote:
>> I can see if that's possible, but I think it's unlikely. They don't
>> even bother following standards (ONFI). Is this an obstacle to
>> merging?
>
> No. I already pushed it.

This is a "bump" for a 3.7-rc pull request. This regression has been
noticed by others.

Thanks,
Brian
