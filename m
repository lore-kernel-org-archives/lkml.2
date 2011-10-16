Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1JPLiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 07:38:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49757 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1JPLip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 07:38:45 -0400
Subject: Re: [PATCH 14/26] mtd: nand_h1900 never worked
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jamie Iles <jamie@jamieiles.com>
Date: Sun, 16 Oct 2011 14:38:14 +0300
In-Reply-To: <1317499438-14058-15-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
	 <1317499438-14058-15-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318765103.2935.3.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-01 at 22:03 +0200, Arnd Bergmann wrote:
> This driver has been broken through all of git history and
> cannot even be built. Better mark it as broken. Next stop is
> removing from the tree.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Pushed to l2-mtd-2.6.git, thanks!

NB: I'd just killed it instead...

-- 
Best Regards,
Artem Bityutskiy

