Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1HVHkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 03:40:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49827 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1HVHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 03:40:27 -0400
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: david.wagner@free-electrons.com
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 22 Aug 2011 10:42:13 +0300
In-Reply-To: <1313587042-30846-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1313587042-30846-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313998939.2644.52.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 15:17 +0200, david.wagner@free-electrons.com
wrote:
> Questions:
> ==========
> I wasn't sure what magic ioctl number to use, so I settled to use the same one
> as a part of UBI: 'O', which was so far only used by UBI but on a higher range
> and leaving some room for UBI to add ioctls (for nw, it uses 'O'/0x00-0x06 and
> ubiblk uses 'O'/0x10-0x11).  Is it ok or should ubiblk use a different
> number/range ?

I think this is OK to share them between UBI and ubiblk, as long as this
is documented. But I always CC Arnd when it comes to ioctl-related
questions.

P.S. Arnd, you can always find the initial post in lkml, if needed.

-- 
Best Regards,
Artem Bityutskiy

