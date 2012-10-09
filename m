Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2JIOYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:24:55 -0400
Received: from mxout1.idt.com ([157.165.5.25]:46140 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab2JIOYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:24:53 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: David Daney <ddaney.cavm@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Jiri Kosina <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Chad Reese <kreese@caviumnetworks.com>
Subject: RE: [PATCH] RapidIO: Fix trivial comment error.
Thread-Topic: [PATCH] RapidIO: Fix trivial comment error.
Thread-Index: AQHNpbaB/iyteJRrikGXa0mgAg7zgZexBxsw
Date: Tue, 9 Oct 2012 14:22:03 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BBFDED7@corpmail1.na.ads.idt.com>
References: <1349743112-27667-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1349743112-27667-1-git-send-email-ddaney.cavm@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Daney [mailto:ddaney.cavm@gmail.com]
> Sent: Monday, October 08, 2012 8:39 PM
> To: Matt Porter; Bounine, Alexandre; Jiri Kosina
> Cc: linux-kernel@vger.kernel.org; David Daney; Chad Reese
> Subject: [PATCH] RapidIO: Fix trivial comment error.
> 
> From: Chad Reese <kreese@caviumnetworks.com>
> 
> The resource index for the mailboxes was incorrect.
> 
> Signed-off-by: Chad Reese <kreese@caviumnetworks.com>
> ---
>  include/linux/rio.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/rio.h b/include/linux/rio.h
> index dc0c755..dd418d1 100644
> --- a/include/linux/rio.h
> +++ b/include/linux/rio.h
> @@ -58,7 +58,7 @@
>   *
>   *	0	RapidIO inbound doorbells
>   *	1	RapidIO inbound mailboxes
> - *	1	RapidIO outbound mailboxes
> + *	2	RapidIO outbound mailboxes
>   */
>  #define RIO_DOORBELL_RESOURCE	0
>  #define RIO_INB_MBOX_RESOURCE	1
> --
> 1.7.11.4

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

