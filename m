Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab0ISHRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 03:17:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46361 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0ISHRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 03:17:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VrEsbBYN/6sG3aqWdgMALCnef3RjGlT8v+bgzbpmgtdr+4mg0koFj52Ix6LhsTe1fa
         9twbN6PBZpzbbRz0LJmSz/N5KyW6KVZRgzRBcVAJLwOJC5C6W8tuT+3F+e800kI4NVkf
         dgtDV5F7ZGucG6GAYxIyJbDJp6ydDtE289NQc=
Subject: Re: [PATCH v4] mtd: nand: Expand nand_ecc_layout, deprecate ioctl
 ECCGETLAYOUT
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <computersforpeace@gmail.com>
Cc: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Sneha Narnakaje <nsnehaprabha@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>
In-Reply-To: <4C951B2A.1000706@gmail.com>
References: <4C5CA4A1.1040000@broadcom.com>
	 <1282154806-9420-1-git-send-email-norris@broadcom.com>
	 <4C6DD170.1060807@renesas.com>  <4C6E9C23.6060703@broadcom.com>
	 <1282646703.24044.162.camel@localhost>  <4C746DE0.7000104@gmail.com>
	 <1283163647.12995.43.camel@brekeke> <1284830690.1721.3.camel@brekeke>
	 <4C951B2A.1000706@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 10:17:50 +0300
Message-ID: <1284880670.1721.111.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-18 at 13:03 -0700, Brian Norris wrote:
> On 9/18/2010 10:24 AM, Artem Bityutskiy wrote:
> > Brian,
> > 
> > would you address the small things I noticed in a follow-up patch?
> 
> Artem,
> 
> Yes, I will. I'm sorry for the delay; I've been a little busy and
> putting some things off. Would you like a patch for the comments against
> your l2 tree or try and squash it with my previous commit and base it
> off of mtd-2.6 or some other option?

No, against l2 tree is ok, I'll put it on top, thanks!

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

