Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab0HHKd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 06:33:26 -0400
Received: from smtp.nokia.com ([192.100.122.230]:31396 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab0HHKdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 06:33:21 -0400
Subject: Re: [PATCH 2/2] drivers/mtd/ubi: Eliminate update of
 list_for_each_entry loop cursor
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1008071109140.5821@ask.diku.dk>
References: <Pine.LNX.4.64.1008071109140.5821@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Aug 2010 13:25:07 +0300
Message-ID: <1281263107.2384.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Aug 2010 10:26:50.0048 (UTC) FILETIME=[363B2400:01CB36E4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-07 at 11:09 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> list_for_each_entry uses its first argument to move from one element to the
> next, so modifying it can break the iteration.  The variable re1 is already
> used within the loop as a temporary variable, and is not live here.

Looks good, thanks, I'll push it to the UBI tree a bit later.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

