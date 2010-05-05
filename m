Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab0EEF5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:57:46 -0400
Received: from smtp.nokia.com ([192.100.105.134]:30720 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0EEF5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:57:45 -0400
Subject: Re: [PATCH] sst25l.c: remove unnecessary MTD_DEBUG_LEVEL2 messages
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
       "andre@bluewatersys.com" <andre@bluewatersys.com>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <0D753D10438DA54287A00B0270842697636E825604@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636E825604@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 08:51:17 +0300
Message-ID: <1273038677.3702.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 05:57:33.0152 (UTC) FILETIME=[DABA3600:01CAEC17]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 17:52 -0500, H Hartley Sweeten wrote:
> All the SST25L series flash parts have uniform erase sectors.  Remove
> the extra MTD_DEBUG_LEVEL2 messages showing the eraseregions info
> since they could never be shown.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Andre Renaud <andre@bluewatersys.com>
> Cc: Ryan Mallon <ryan@bluewatersys.com>

Pushed to l2-mtd-2.6 / master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

