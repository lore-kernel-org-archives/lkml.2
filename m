Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2JVT4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:56:39 -0400
Received: from server505c.appriver.com ([98.129.35.7]:1703 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752877Ab2JVT4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:56:37 -0400
X-Note-AR-ScanTimeLocal: 10/22/2012 2:56:34 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G329 G330 G331 G332 G336 G337 G348 G444 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Oct 2012 14:56:32 -0500
Subject: Re: [PATCH] aoe: remove unused variable in resend()
Thread-Topic: [PATCH] aoe: remove unused variable in resend()
Thread-Index: Ac2wj1Wg/zDxkvqoTCmIods27dIYdw==
Message-ID: <DFBFBFD3-4B29-4233-B109-C6AFFB57BBF2@coraid.com>
References: <CAPgLHd9yWbukGH_mNJo0fRmG7q8RctQghPQo8wxBn_n8hzn=zQ@mail.gmail.com>
In-Reply-To: <CAPgLHd9yWbukGH_mNJo0fRmG7q8RctQghPQo8wxBn_n8hzn=zQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, thanks.

On Oct 22, 2012, at 5:17 AM, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The variable ah is initialized but never used
> otherwise, so remove the unused variable.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
> drivers/block/aoe/aoecmd.c | 2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index 3804a0a..812eb8a 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -425,7 +425,6 @@ resend(struct aoedev *d, struct frame *f)
> 	struct sk_buff *skb;
> 	struct sk_buff_head queue;
> 	struct aoe_hdr *h;
> -	struct aoe_atahdr *ah;
> 	struct aoetgt *t;
> 	char buf[128];
> 	u32 n;
> @@ -440,7 +439,6 @@ resend(struct aoedev *d, struct frame *f)
> 		return;
> 	}
> 	h = (struct aoe_hdr *) skb_mac_header(skb);
> -	ah = (struct aoe_atahdr *) (h+1);
> 
> 	snprintf(buf, sizeof buf,
> 		"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x s=%pm d=%pm nout=%d\n",
> 

-- 
  Ed Cashin
  ecashin@coraid.com


