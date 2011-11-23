Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1KWL0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:26:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58902 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1KWL0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:26:42 -0500
X-AuditID: cbfee60d-b7bbbae0000011e7-db-4eccd871dcb0
Date: Wed, 23 Nov 2011 11:26:41 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] max8997_charger: Remove duplicate module.h
To: =?euc-kr?Q?=C3=D6=C1=BE=C8=AF?= <jhbird.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111123112448277@myungjoo.ham
Msgkey: 20111123112448277@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111123112448277@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <16505126.116361322047601084.JavaMail.weblogic@epml27>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pANBQpkW007208

Sender : ÃÖÁ¾È¯<jhbird.choi@samsung.com> S4(¼±ÀÓ)/¼±ÀÓ/S/W Solution°³¹ßÆÀ(S.LSI)/»ï¼ºÀüÀÚ
Date : 2011-11-23 13:40 (GMT+09:00)
Title : [PATCH] max8997_charger: Remove duplicate module.h
> 
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> module.h was included twice.
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
> drivers/power/max8997_charger.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
> index a23317d..ffc5033 100644
> --- a/drivers/power/max8997_charger.c
> +++ b/drivers/power/max8997_charger.c
> @@ -19,7 +19,6 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
> 
> -#include 
> #include 
> #include 
> #include 
> -- 
> 1.7.1
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
