Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab2CSP1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:27:47 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:13488
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754889Ab2CSP1q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:27:46 -0400
X-SpamScore: -14
X-BigFish: PS-14(zz9371I542M1432N1a09Jzz1202hzz8275bh8275dhz2fh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:157.55.61.13;KIP:(null);UIP:(null);IPV:NLI;H:CH1PRD0802HT007.namprd08.prod.outlook.com;RD:none;EFVD:NLI
From: Chris Kelly <ckelly@ozmodevices.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH 2/5]NEXT:drivers:staging:ozwpan:ozhcd.c Fix typos in
 staging:ozwpan
Thread-Topic: [PATCH 2/5]NEXT:drivers:staging:ozwpan:ozhcd.c Fix typos in
 staging:ozwpan
Thread-Index: AQHNBeN+tef7bX4RzEWzXlYDTLBjAJZxu+Hg
Date: Mon, 19 Mar 2012 15:27:39 +0000
Message-ID: <57C28D85C66F5C49B9E212CBFAFDAC1F2D3ACCBE@CH1PRD0802MB120.namprd08.prod.outlook.com>
References: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
 <1332170273-3482-2-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1332170273-3482-2-git-send-email-justinmattock@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.42.111.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,
Many thanks.
Chris Kelly

> -----Original Message-----
> From: Justin P. Mattock [mailto:justinmattock@gmail.com] 
> Sent: 19 March 2012 3:18 PM
> To: linux-kernel@vger.kernel.org
> Cc: gregkh@linuxfoundation.org; Justin P. Mattock; Chris Kelly
> Subject: [PATCH 2/5]NEXT:drivers:staging:ozwpan:ozhcd.c Fix typos in staging:ozwpan
>
> From: "Justin P. Mattock" <justinmattock@gmail.com>
>
> The below patch fixes a typo that I found while reading.
>
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Acked-by: Chris Kelly <ckelly@ozmodevices.com>
> Cc: Chris Kelly <ckelly@ozmodevices.com>
> ---
>  drivers/staging/ozwpan/ozhcd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c index 750b14e..cfa25e8 100644
> --- a/drivers/staging/ozwpan/ozhcd.c
> +++ b/drivers/staging/ozwpan/ozhcd.c
> @@ -1463,7 +1463,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
>  			rc = -ENOMEM;
>  		} else {
>  			/* Note: we are queuing the request after we have
> -			 * submitted it to be tranmitted. If the request were
> +			 * submitted it to be transmitted. If the request were
>  			 * to complete before we queued it then it would not
>  			 * be found in the queue. It seems impossible for
>  			 * this to happen but if it did the request would
> --
> 1.7.5.4


