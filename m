Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab1HQEzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 00:55:55 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:44647 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1HQEzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 00:55:54 -0400
Subject: Re: [PATCH] mtd: plat_nand: fix `bbt_options' compile error
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, avorontsov@ru.mvista.com,
        axel.lin@gmail.com
Date: Wed, 17 Aug 2011 07:57:34 +0300
In-Reply-To: <CAN8TOE_DUqzcwQnLQ8TEqoOX3D8Rn1ZxJuSpQbabPfDd83PQUA@mail.gmail.com>
References: <1312827993-19163-1-git-send-email-computersforpeace@gmail.com>
	 <1313502412.21711.1.camel@sauron>
	 <CAN8TOE_DUqzcwQnLQ8TEqoOX3D8Rn1ZxJuSpQbabPfDd83PQUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313557059.2679.6.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 15:15 -0700, Brian Norris wrote:
> On Tue, Aug 16, 2011 at 6:46 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > Merged this fix with that commit in the l2-mtd-2.6.git tree, thanks!
> 
> I don't see any "merge." Perhaps an oversight on the push?

Yes, fixed.

-- 
Best Regards,
Artem Bityutskiy

