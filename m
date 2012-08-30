Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2H3Gu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 02:50:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24228 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2H3Gu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 02:50:27 -0400
X-AuditID: cbfee611-b7fd76d00000288b-21-503f0d31df29
Date: Thu, 30 Aug 2012 06:50:25 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] PM/devfreq: Use devm_* functions in exynos4_bus.c
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "patches@linaro.org" <patches@linaro.org>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120830064843019@myungjoo.ham
Msgkey: 20120830064843019@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120830064843019@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <22771352.55091346309425371.JavaMail.weblogic@epml19>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/t6bqGvPYBBp0/bSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG8f0zmAvesFRsP7mdpYHxBksXIyeHkIC6xKIlJ9lAbAkBE4lv
	f/8zQthiEhfurQeKcwHVzGeU+HhpHTNIgkVAVeLmix7WLkYODjYBc4n7M4JAwsICbhJP7n9m
	B7FFBHIlXu39DTaTWSBJ4vqFiVC7lCTW7HsFZvMKCEqcnPmEBWKXqsTLhb2MEHE1ievbVkLd
	ICExa/oFVgibV2JG+1OoejmJaV/XMEPY0hLnZ22Au3nx98dQcX6JY7d3MIGcCdL75H4wzJjd
	m79AvSsgMfXMQahWLYnf7/ZAreKTWLPwLQvMmF2nljPD9N7fMpcJ4i1FiSndD9khbC2JLz/2
	saF6iwPIdpQ4sI1vAqPcLCSZWUi6ZyHpRlazgJFlFaNoakFyQXFSeqq5XnFibnFpXrpecn7u
	JkZwjD8T3MG4tMHiEKMAB6MSDy9Hpl2AEGtiWXFl7iFGCQ5mJRHeHXeBQrwpiZVVqUX58UWl
	OanFhxilOViUxHnnvPjiLySQnliSmp2aWpBaBJNl4uCUamB0lL1fZ5j2sDz0ela6ekDTobui
	wQfsequr/3zWfVq2LdfhWPOJKo8PgpZz+Pf8XZf4q5bV7nyg3NN9p2528u4wfs8q48Sy6Y+x
	l/b8r+kaAuVOk2/MFWdkuSclHV+5Ury09+ufsBkPj081nmGzYu+e3YevSc6rzZmy+1makrG2
	6sLsZ8z+TZJKLMUZiYZazEXFiQDjx1kJ7QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7U6olD6024002

> devm_* functions are device managed functions and make cleanup code
> simpler and smaller.
> devm_kzalloc and devm_regulator_get functions are used.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied to http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/devfreq-for-next
It will appear in some hours.

Thanks.


Cheers!
MyungJoo
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
