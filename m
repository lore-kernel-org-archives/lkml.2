Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965748Ab0COTSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:18:16 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38515 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965718Ab0COTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:18:15 -0400
Date: Mon, 15 Mar 2010 20:18:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mac_structures.h Fixed indentation,
 whitespace etc
Message-ID: <20100315191804.GA23292@elf.ucw.cz>
References: <1268674900-9663-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268674900-9663-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-15 18:41:40, Lars Lindley wrote:
> I fixed all problems reported by checkpatch.pl except typedefs.

...which only shows how little problems checkpatch detects.

> --- a/drivers/staging/winbond/mac_structures.h

> +/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> + * MAC_Structures.h
> + *
> + * This file contains the definitions and data structures used by SW-MAC.
> + *
> + * Revision Histoy
> + * =================
> + * 0.1      2002        UN00
> + * 0.2      20021004    PD43 CCLiu6
> + *          20021018    PD43 CCLiu6
> + *                      Add enum_TxRate type
> + *                      Modify enum_STAState type
> + * 0.3      20021023    PE23 CYLiu update MAC session struct
> + *          20021108
> + *          20021122    PD43 Austin
> + *                      Deleted some unused.
> + *          20021129    PD43 Austin
> + *			20030617	increase the 802.11g
> definition

Get rid of revision history; it does not make sense, is not english,
and just should not be there.

> +/*----- Some miscellaneous definitions */
> +#define MAX_CHANNELS				30
> +#define MAC_ADDR_LENGTH				6
> +#define MAX_WEP_KEY_SIZE			16  /* 128 bits */
> +#define	MAX_802_11_FRAGMENT_NUMBER		10  /* By spec */

Consistent tabs vs spaces?

> +#define REASON_IE_DIFF_4WAY_ASSOC		17
> +#define REASON_INVALID_MULTICAST_CIPHER		18
> +#define REASON_INVALID_UNICAST_CIPHER		19
> +#define REASON_INVALID_AKMP			20
> +#define REASON_UNSUPPORTED_RSNIE_VERSION	21
> +#define REASON_INVALID_RSNIE_CAPABILITY		22
> +#define REASON_802_1X_AUTH_FAIL			23
> +#define	REASON_CIPHER_REJECT_PER_SEC_POLICY	14

Same here.

> +	// SUCCESS   = 0,      **** Redefined
> +	UNSPECIFIED_FAILURE				= 1,

I thought you was killing C++ comments?

> +struct PHY_Parameter_Set_Element {
> +/*	int	aSlotTime; */
> +/*	int	aSifsTime; */

Commented out code should be killed, not commented out in nicer way.

> +/*Authentication suite*/

Spaces after /* and before */...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
