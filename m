Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab0DAMaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:30:08 -0400
Received: from smtp.nokia.com ([192.100.122.233]:24106 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0DAM37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:29:59 -0400
Subject: Re: [PATCH] [mtd, nandsim] Fix typo: struct nandsin_geometry
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <87aaul1d67.fsf@tac.ki.iif.hu>
References: <87aaul1d67.fsf@tac.ki.iif.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 15:27:22 +0300
Message-ID: <1270124842.15073.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2010 12:29:36.0188 (UTC) FILETIME=[FD8127C0:01CAD196]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-06 at 20:08 +0100, Ferenc Wagner wrote:
> Actually, this embedded struct (together with nandsim_regs) could as well
> remain nameless...
> 
> Signed-off-by: Ferenc Wagner <wferi@niif.hu>
> ---
>  drivers/mtd/nand/nandsim.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
> index 7281000..803ae12 100644
> --- a/drivers/mtd/nand/nandsim.c
> +++ b/drivers/mtd/nand/nandsim.c
> @@ -312,7 +312,7 @@ struct nandsim {
>  	union ns_mem buf;
>  
>  	/* NAND flash "geometry" */
> -	struct nandsin_geometry {
> +	struct nandsim_geometry {
>  		uint64_t totsz;     /* total flash size, bytes */
>  		uint32_t secsz;     /* flash sector (erase block) size, bytes */
>  		uint pgsz;          /* NAND flash page size, bytes */

Instead of taking your patch, I've made this structure anonymous as well
as few other structures. See
http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/833ba5e74a8b141ea7d7b318d6ac8c112659efa6

I've referred you as the person who suggested the change.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

