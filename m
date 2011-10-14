Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1JNJEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:04:37 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61827 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1JNJEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:04:36 -0400
Subject: Re: [PATCH V6] mtd: Add DiskOnChip G3 support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: dwmw2@infradead.org, arnd@arndb.de, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Oct 2011 12:04:03 +0300
In-Reply-To: <1317820954-24902-1-git-send-email-robert.jarzmik@free.fr>
References: <1317820954-24902-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318583051.12351.75.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 15:22 +0200, Robert Jarzmik wrote:
> Add support for DiskOnChip G3 chips. The support is quite
> limited yet :
>  - no flash writes/erases are implemented
>  - ECC fixes are not implemented
>  - powerdown is not implemented
>  - IPL handling is not yet done
> 
> On the brighter side, the chip reading does work.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

