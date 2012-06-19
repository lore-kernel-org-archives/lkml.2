Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2FSKaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:30:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51647 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2FSKah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:30:37 -0400
X-AuditID: cbfee610-b7fcc6d00000671d-10-4fe054cc633b
Date: Tue, 19 Jun 2012 10:30:36 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/2] extcon: Convert extcon_gpio to devm_gpio_request_one
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Lockwood <lockwood@android.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        cw00.choi@samsung.com, kyungmin.park@samsung.com
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120619102954900@myungjoo.ham
Msgkey: 20120619102954900@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120619102954900@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <30343544.601351340101836224.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t/tGbpnQh74G1xfbWhxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgytvxrZStoY6m4fvkkWwPjF+YuRk4OIQF1iUVLTrKB2BICJhKb
	juxmhLDFJC7cWw8U5wKqmc8oMaf5EitIgkVAVeLhz3aWLkYODjYBPYmZn5NBwsICvhJHpn5j
	AbFFBFIkOifPZwfpZRa4wihxcccsqGVKEmv2vQIr4hUQlDg58wkLxDJViVPX9zFCxNUkDk66
	xQQRl5CYNf0CK4TNKzGj/SlUvZzEtK9rmCFsaYnzszbAHb34+2OoOL/Esds7mEDuBOl9cj8Y
	ZszuzV+g/hWQmHrmIFSrlsSazrdQrXwSaxa+ZYEZs+vUcrA4s4CixJTuh+wQtpbElx/72NC9
	wivgJLFo+S3mCYyys5CkZiFpn4WkHVnNAkaWVYyiqQXJBcVJ6almesWJucWleel6yfm5mxjB
	8fxMYAfjkgaLQ4wCHIxKPLw//B/4C7EmlhVX5h5ilOBgVhLhXfX/vr8Qb0piZVVqUX58UWlO
	avEhRmkOFiVx3l7rC/5CAumJJanZqakFqUUwWSYOTqkGRtfrHvEefSYKTe93bdpnMMUg10xQ
	6ZC3Z09vnIdu6d5Wy97fVS/O3jGceUKVa57BrSNTxZekJnxzjWY8f65rTZoW8/TFG19Gub3p
	nXczsUr+cVex1JYGs7vB7HfEGEKCNtTYX0/kqzU5Gtu0NjvVcXPOJG++G7kKGRtmL35ae+7r
	0TVCnxVLlFiKMxINtZiLihMBJxQbb+MCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5JAUikj027246

> Also remove unneeded devm_kfree calls.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


Thanks!

You will be able to see this patch along with other extcon patches at the infradead repository soon:
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next

Cheers!
MyungJoo.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
