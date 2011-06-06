Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1FFKLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:11:33 -0400
Received: from smtp.nokia.com ([147.243.1.48]:54733 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1FFKLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:11:32 -0400
Subject: Re: [PATCH] mtd: denali: remove calling mtd_device_unregister()
 after nand_release()
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        linux-mtd@lists.infradead.org,
        David Woodhouse <David.Woodhouse@intel.com>
In-Reply-To: <1307063535.10001.1.camel@phoenix>
References: <1307063535.10001.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 06 Jun 2011 13:07:09 +0300
Message-ID: <1307354829.3112.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 09:12 +0800, Axel Lin wrote:
> The implementation of nand_release() already call mtd_device_unregister(),
> no need to call it again.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

