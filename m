Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1HPNpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:45:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39158 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1HPNpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:45:08 -0400
Subject: Re: [PATCH] mtd: plat_nand: fix `bbt_options' compile error
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, avorontsov@ru.mvista.com,
        axel.lin@gmail.com
Date: Tue, 16 Aug 2011 16:46:47 +0300
In-Reply-To: <1312827993-19163-1-git-send-email-computersforpeace@gmail.com>
References: <1312827993-19163-1-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313502412.21711.1.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 11:26 -0700, Brian Norris wrote:
> This fixes a bug in commit 86cb232d4e6b589be3daef8d570d1921c05be962
> ("mtd: nand: consolidate redundant flash-based BBT flags"). The problem
> was reported by Axel Lin at:

Merged this fix with that commit in the l2-mtd-2.6.git tree, thanks!

-- 
Best Regards,
Artem Bityutskiy

