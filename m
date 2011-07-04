Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1GDGgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 02:36:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62235 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1GDGgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 02:36:19 -0400
Subject: Re: [PATCH] mtd: plat-nand: Fixup kerneldoc for struct
 platform_nand_chip
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tobias Klauser <tklauser@distanz.ch>
Cc: David Woodhouse <dwmw2@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Jul 2011 09:37:16 +0300
In-Reply-To: <1309521075-18106-1-git-send-email-tklauser@distanz.ch>
References: <1309521075-18106-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309761441.23597.210.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 13:51 +0200, Tobias Klauser wrote:
> The set_parts and priv members of struct platform_nand_chip where
> removed in commit c36a6ef3845262ade529afb9f458738b1f196f83 but the
> kerneldoc wasn't updated.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

