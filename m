Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2FKFh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:37:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36554 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2FKFhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:37:55 -0400
X-AuditID: cbfee611-b7fbe6d0000069df-0f-4fd584301fc5
Date: Mon, 11 Jun 2012 05:37:52 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/1] PM: devfreq: Add missing static storage class
 specifier in devfreq.c file
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "patches@linaro.org" <patches@linaro.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120611053604039@myungjoo.ham
Msgkey: 20120611053604039@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120611053604039@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <32123437.782611339393071788.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/tGboGLVf9DeYukLK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ/de62QrecVbsW7iHrYHxBGcXIyeHkIC6xKIlJ9lAbAkBE4ld
	B3eyQthiEhfurQeKcwHVzGeU6Pp9BayIRUBV4uPFFUA2BwebgJ7EzM/JIGFhgSSJObNfgZWI
	CORKvNr7G8xmFsiTmDj1MRPELiWJNftesYDYvAKCEidnPmEBGSMBNPLZdW4Qk1dATeJXRyTE
	BRISs6ZfgLqGV2JG+1MWCFtOYtrXNcwQtrTE+VkbGGEuXvz9MVScX+LY7R1MENN5JZ7cD4YZ
	s3vzF6hnBSSmnjkI1aolcar3MZTNJ7Fm4VsWmDG7Ti1nhnhEUWJK90N2CFtL4suPfWyoHgGx
	nSQOzW5gnMAoOwtJahaS9llI2pHVLGBkWcUomlqQXFCclJ5qrlecmFtcmpeul5yfu4kRHMnP
	BHcwLm2wOMQowMGoxMPL0HDVX4g1say4MvcQowQHs5II77YKoBBvSmJlVWpRfnxRaU5q8SFG
	aQ4WJXHePusL/kIC6YklqdmpqQWpRTBZJg5OKWBSMHqYUi1dfHLi6TJPO7nTp565blrjcdTx
	votdonFW3rfzj+asFT5zLlB19jQVtr2Pg9+svWTKLVPYe+n1tSSNU7NN/4osqTm2ev2u9f9a
	UvikXvu/Zd/vILVtEffmMKVjHSfWqQa0Lb3y+O2R1CfPX/AssJ30Ylvn41bT7bJSxr7JZzpz
	2xfyKLEUZyQaajEXFScCACekH4DgAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5B5c9jn006786

> Fixes the following sparse warning:
> drivers/devfreq/devfreq.c:30:14: warning: symbol 'devfreq_class' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Signed-off-by: MyungJoo Ham <myunhjoo.ham@samsung.com>

Merged in the devfreq-for-next tree. I'll later send pull a request along with other patches.


Cheers!
MyungJoo.

> ---
>  drivers/devfreq/devfreq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 70c31d4..9eb6805 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -27,7 +27,7 @@
>  #include <linux/hrtimer.h>
>  #include "governor.h"
>  
> -struct class *devfreq_class;
> +static struct class *devfreq_class;
>  
>  /*
>   * devfreq_work periodically monitors every registered device.
> -- 
> 1.7.4.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
