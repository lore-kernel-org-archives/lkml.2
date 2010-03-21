Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0CUUEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:04:15 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38389 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752496Ab0CUUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:04:13 -0400
Date: Sun, 21 Mar 2010 21:04:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mds_f.h whitespace and CamelCase
 corrections.
Message-ID: <20100321200406.GC1933@elf.ucw.cz>
References: <1268902493-27493-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268902493-27493-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-03-18 09:54:53, Lars Lindley wrote:
> I fixed the whitespaces, the C99 comment and the CamelCase
> parameter names.
> New patch against master -> forget the old patch:
> Message-Id: <1268899193-16034-1-git-send-email-lindley@coyote.org>
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

> ---
>  drivers/staging/winbond/mds_f.h |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
> index e09dd4b..20e97bf 100644
> --- a/drivers/staging/winbond/mds_f.h
> +++ b/drivers/staging/winbond/mds_f.h
> @@ -4,17 +4,17 @@
>  #include "wbhal_s.h"
>  #include "core.h"
>  
> -unsigned char Mds_initial(  struct wbsoft_priv *adapter );
> -void Mds_Destroy(  struct wbsoft_priv *adapter );
> -void Mds_Tx(  struct wbsoft_priv *adapter );
> -void Mds_SendComplete(  struct wbsoft_priv *adapter,  PT02_DESCRIPTOR pT02 );
> -void Mds_MpduProcess(  struct wbsoft_priv *adapter,  struct wb35_descriptor *pRxDes );
> +unsigned char Mds_initial(struct wbsoft_priv *adapter);
> +void Mds_Destroy(struct wbsoft_priv *adapter);
> +void Mds_Tx(struct wbsoft_priv *adapter);
> +void Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pt02);
> +void Mds_MpduProcess(struct wbsoft_priv *adapter, struct wb35_descriptor *prxdes);
>  extern void DataDmp(u8 *pdata, u32 len, u32 offset);
>  
> -// For data frame sending 20060802
> -u16 MDS_GetPacketSize(  struct wbsoft_priv *adapter );
> -void MDS_GetNextPacket(  struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes );
> -void MDS_GetNextPacketComplete(  struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes );
> -void MDS_SendResult(  struct wbsoft_priv *adapter,  u8 PacketId,  unsigned char SendOK );
> +/* For data frame sending */
> +u16 MDS_GetPacketSize(struct wbsoft_priv *adapter);
> +void MDS_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pdes);
> +void MDS_GetNextPacketComplete(struct wbsoft_priv *adapter, struct wb35_descriptor *pdes);
> +void MDS_SendResult(struct wbsoft_priv *adapter, u8 packetid, unsigned char sendok);
>  
>  #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
