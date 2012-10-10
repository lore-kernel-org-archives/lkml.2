Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2JJKq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:46:29 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:34748 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2JJKq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:46:28 -0400
X-Auth-Info: LbGyNmTS7BK+B2vnRDfloYAq/7PI49V2iaezwLsg3/8=
From: Marek Vasut <marex@denx.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH for 3.7] mtd: nand: fix Samsung SLC NAND identification regression
Date: Wed, 10 Oct 2012 12:35:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Brian Norris <computersforpeace@gmail.com>, linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
References: <1349850366-4731-1-git-send-email-computersforpeace@gmail.com> <CAN8TOE-ZLyCanBx8pqsbzY6jMQq+ysiVvdLmWvO8QdnyZg1QRg@mail.gmail.com> <1349855329.6072.72.camel@shinybook.infradead.org>
In-Reply-To: <1349855329.6072.72.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210101235.55741.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David Woodhouse,

> On Tue, 2012-10-09 at 23:39 -0700, Brian Norris wrote:
> > I can see if that's possible, but I think it's unlikely. They don't
> > even bother following standards (ONFI). Is this an obstacle to
> > merging?
> 
> No. I already pushed it.

Thanks guys!

Best regards,
Marek Vasut
