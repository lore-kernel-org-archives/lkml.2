Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1FFKXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:23:54 -0400
Received: from smtp.nokia.com ([147.243.1.48]:38621 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab1FFKXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:23:52 -0400
Subject: Re: [PATCH 2/2] mtd: nomadik_nand: add missing nand_release in
 nomadik_nand_remove
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Sachin Verma <sachin.verma@st.com>
In-Reply-To: <1307066006.10001.4.camel@phoenix>
References: <1307065913.10001.2.camel@phoenix>
	 <1307066006.10001.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 06 Jun 2011 13:19:30 +0300
Message-ID: <1307355570.3112.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 09:53 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mtd/nand/nomadik_nand.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

