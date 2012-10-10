Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2JJGj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:39:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47770 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab2JJGjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:39:45 -0400
MIME-Version: 1.0
In-Reply-To: <1349850682.6072.70.camel@shinybook.infradead.org>
References: <1349850366-4731-1-git-send-email-computersforpeace@gmail.com>
	<1349850682.6072.70.camel@shinybook.infradead.org>
Date: Tue, 9 Oct 2012 23:39:43 -0700
Message-ID: <CAN8TOE-ZLyCanBx8pqsbzY6jMQq+ysiVvdLmWvO8QdnyZg1QRg@mail.gmail.com>
Subject: Re: [PATCH for 3.7] mtd: nand: fix Samsung SLC NAND identification regression
From: Brian Norris <computersforpeace@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 11:31 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Tue, 2012-10-09 at 23:26 -0700, Brian Norris wrote:
>> I have heuristically determined that all the chips that use
>> the new table have ID strings which wrap around after the 6th byte.
>
> I'd be happier if we had confirmation of that from Samsung...

I can see if that's possible, but I think it's unlikely. They don't
even bother following standards (ONFI). Is this an obstacle to
merging?

Brian
