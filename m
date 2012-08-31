Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2HaINI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:13:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51186 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2HaINE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:13:04 -0400
X-AuditID: cbfee611-b7fd76d00000288b-07-5040720e3021
Date: Fri, 31 Aug 2012 08:13:02 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: checkpatch warning removal
To: anish kumar <anish198519851985@gmail.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120831081142629@myungjoo.ham
Msgkey: 20120831081142629@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120831081142629@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <14107831.94151346400781515.JavaMail.weblogic@epml19>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/tGbp8RQ4BBusbOC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG99FpjAU9vBW7785nbGC8w9PFyMkhJKAusWjJSTYQW0LAROLL
	z82MELaYxIV764HiXEA18xklHj3ZyQySYBFQlXiy7hJQEQcHm4CexMzPySBhYQFziWWN18BK
	RARyJGatbGYCsZkFHCUeXb7DDLFLSWLNvlcsIDavgKDEyZlPWCB2qUqsXHGUHSKuJvHp7VWo
	GyQkZk2/wAph80rMaH8KVS8nMe3rGmYIW1ri/KwNcDcv/v4YKs4vcez2DiaQM0F6n9wPhhmz
	e/MXqHcFJKaeOQjVqiXRuPAEE4TNJ7Fm4VsWmDG7Ti1nhum9v2Uu1FuKElO6H7JD2FoSX37s
	Y0P1FgeQ7Six9J7BBEa5WUgys5B0z0LSjaxmASPLKkbR1ILkguKk9FRzveLE3OLSvHS95Pzc
	TYzgGH8muINxaYPFIUYBDkYlHt6OXfYBQqyJZcWVuYcYJTiYlUR42awcAoR4UxIrq1KL8uOL
	SnNSiw8xSnOwKInzznnxxV9IID2xJDU7NbUgtQgmy8TBKdXAePe67ppynYiEiXa79l20S53U
	tt5nU3vOFP4fzytDUtbaKn0uDrFIuyQ/8Z7ot6XJUdGbJxlsz7cvlZq6Q2gDj+Hj07En8haV
	K269Vm/yfPnjvxw1v3KenF1+tDDua/SvLqf63LNRxmY76s5Yu6vX79IMWnaOY99Ey13n+nku
	7437PeG06y4NDiWW4oxEQy3mouJEAND45/rtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7V8DEXU028340

> From: anish kumar <anish198519851985@gmail.com>
> 
> without this patch we get below warning:
> WARNING: externs should be avoided in .c files
> 132: FILE: extcon/extcon-class.c:
> int extcon_set_state(struct extcon_dev *edev, u32 state);
> 
> So just removed the declaration.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>

Ah.. yes.. I thought removing it could emit compiler errors.
But, we have it declared in the header file. Good.

Thanks.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/extcon/extcon-class.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 06df95a..6f3391b 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -129,7 +129,6 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
>  	return count;
>  }
>  
> -int extcon_set_state(struct extcon_dev *edev, u32 state);
>  static ssize_t state_store(struct device *dev, struct device_attribute *attr,
>  			   const char *buf, size_t count)
>  {
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
