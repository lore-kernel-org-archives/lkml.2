Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab0CTALL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:11:11 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47451 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752349Ab0CTALJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:11:09 -0400
Date: Sat, 20 Mar 2010 01:10:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx.c Coding style fixes.
Message-ID: <20100320001048.GA1477@ucw.cz>
References: <1269018531-18891-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269018531-18891-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

And thanks for the effort.

> +u8 MLMESendFrame(struct wbsoft_priv *adapter, u8 *mmpdu, u16 len, u8 datatype)
>  {
>  	if (adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE) {
>  		adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
> @@ -30,17 +27,19 @@ u8 MLMESendFrame(struct wbsoft_priv * adapter, u8 *pMMPDU, u16 len, u8 DataType)
>  	}
>  	adapter->sMlmeFrame.IsInUsed = PACKET_COME_FROM_MLME;
>  
> -	// Keep information for sending
> -	adapter->sMlmeFrame.pMMPDU = pMMPDU;
> -	adapter->sMlmeFrame.DataType = DataType;
> -	// len must be the last setting due to QUERY_SIZE_SECOND of Mds
> +	/* Keep information for sending */
> +	adapter->sMlmeFrame.pMMPDU = mmpdu;

I'm not sure if 'mmpdu' is good name. But I don't know what it stands
for, either, so...

> +	adapter->sMlmeFrame.DataType = datatype;

data_type, please...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
