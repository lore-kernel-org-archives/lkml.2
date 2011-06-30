Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1F3MHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:07:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59125 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1F3MHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:07:37 -0400
Subject: Re: [PATCH] mtd: tmio_nand: fix build error
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Thu, 30 Jun 2011 15:08:29 +0300
In-Reply-To: <BANLkTikonD2fcbkBU2ESYm_XncBXNZc_hw@mail.gmail.com>
References: <1309408494.10500.1.camel@phoenix>
	 <BANLkTikonD2fcbkBU2ESYm_XncBXNZc_hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309435714.23597.181.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 12:23 +0400, Dmitry Eremin-Solenikov wrote:
> On 6/30/11, Axel Lin <axel.lin@gmail.com> wrote:
> > Fix a mistake introduced by commit 33f4a3b
> > "mtd: tmio_nand.c: use mtd_device_parse_register"
> 
> Already sumbited 27 June 2011. Strangely Artem remains silent.

I handle my mailbox in FIFO order (with exceptions) so I have not
reached your patch yet. Now I've merged it with one of your previous
patches to keep the kernel bisectable.

Thanks!

-- 
Best Regards,
Artem Bityutskiy

