Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2HTG4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:56:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16463 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab2HTG4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:56:41 -0400
X-AuditID: cbfee611-b7fd76d00000288b-c2-5031dfa72f71
Date: Mon, 20 Aug 2012 06:56:39 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] Extcon: Minor change in the declaration of cable_names
To: anish kumar <anish198519851985@gmail.com>
Cc: =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120820065513072@myungjoo.ham
Msgkey: 20120820065513072@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120820065513072@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <28057486.209671345445798709.JavaMail.weblogic@epml13>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t/t6brL7xsGGPw7KG9xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyrnV8YC3oEaw4OmMZewPjBYEuRk4OIQF1iUVLTrKB2BICJhKP
	Z+xhgrDFJC7cW88GUTOfUeJ+h0kXIwcHi4CqxPYeBxCTTcBc4v6MIJAKYQFviafNX8GqRQT0
	JeZMmAlmMwvUSXS3LGCGmKIksWbfKxYQm1dAUOLkzCcsEJtUJb6ufAwVV5P4tbiFESIuITFr
	+gVWCJtXYkb7U6h6OYlpX9cwQ9jSEudnbWCEuXjx98dQcX6JY7d3MIGcCdL75H4wzJjdm79A
	PSsgMfXMQUaIEi2J89cSIMJ8EmsWvmWBmbLr1HJmmNb7W+YyQXylKDGl+yE7hK0l8eXHPjZ0
	X/EKOEl8OHWUcQKj3CwkqVlI2mchaUdWs4CRZRWjaGpBckFxUnqquV5xYm5xaV66XnJ+7iZG
	cHw/E9zBuLTB4hCjAAejEg/v6emGAUKsiWXFlbmHGCU4mJVEeGWOAoV4UxIrq1KL8uOLSnNS
	iw8xSnOwKInzznnxxV9IID2xJDU7NbUgtQgmy8TBKdXAWHrJey/LvwJtXqkVWnM+3C9/6X11
	waXUCP7p25oPPZHQtO97tm/t9QnG87/4z7G8lLGP+8P7UyxntkiqSYQW7jp5oOGYjKfphrII
	ezX3qMXdvmEeu6efS2EXFD/kNecC28QZP2wXa2hKR31QexiYmNpwyFU3p9JO1sd++4m0tMvi
	fGVyk9ndlViKMxINtZiLihMB1e0wxOsCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7K6umfV011425

> From: anish kumar <anish198519851985@gmail.com>
> 
> Instead of "const char **supported_cable" it is better to have
> it as "const char *const *supported_cable".
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>

Could you please elaborate on why it's better?

(Is this fixing the using the standard naming issue Mark mentioned before?)


Cheers!
MyungJoo

> ---
>  include/linux/extcon.h                 |    2 +-
>  include/linux/extcon/extcon-adc-jack.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index cdd4014..a6bcc29 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -111,7 +111,7 @@ struct extcon_cable;
>  struct extcon_dev {
>  	/* --- Optional user initializing data --- */
>  	const char	*name;
> -	const char **supported_cable;
> +	const char *const *supported_cable;
>  	const u32	*mutually_exclusive;
>  
>  	/* --- Optional callbacks to override class functions --- */
> diff --git a/include/linux/extcon/extcon-adc-jack.h b/include/linux/extcon/extcon-adc-jack.h
> index 20e9eef..f27f2e8 100644
> --- a/include/linux/extcon/extcon-adc-jack.h
> +++ b/include/linux/extcon/extcon-adc-jack.h
> @@ -60,7 +60,7 @@ struct adc_jack_pdata {
>  	/*
>  	 * The last entry should be NULL
>  	 */
> -	const char **cable_names;
> +	const char *const *cable_names;
>  	/* The last entry's state should be 0 */
>  	struct adc_jack_cond *adc_conditions;
>  
> -- 
> 1.7.1
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
