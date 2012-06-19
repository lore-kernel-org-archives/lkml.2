Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2FSFuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:50:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36306 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab2FSFuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:50:01 -0400
X-AuditID: cbfee60c-b7fe66d0000058a5-8f-4fe012f80aaf
Date: Tue, 19 Jun 2012 05:49:44 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: RE: RE: Re: [PATCH 1/2] PM: devfreq: add freq table and
 available_freqs
To: Xiaoguang Chen <chenxg@marvell.com>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120619054934475@myungjoo.ham
Msgkey: 20120619054934475@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120619054934475@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <5366749.590331340084982845.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t/tmbo/hB74G1zeJGJxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgynjf0sBcsYq149mMycwNjD2sXIyeHkIC6xKIlJ9lAbAkBE4ld
	v7cxQdhiEhfurQeKcwHVzGeUOPb5NTtIgkVAVeLAt/ssXYwcHGwC5hL3ZwSBhIUFQiR657eC
	zRERiJBYu+MzM0gvs0Abk0Rv7wk2iGVKEmv2vWIBsXkFBCVOznzCArFMVWLnoResEHE1iRnT
	jkMdISExa/oFVgibV2JG+1OoejmJaV/XMEPY0hLnZ21ghDl68ffHUHF+iWO3dzCB3AnS++R+
	MMyY3Zu/QP0rIDH1zEGoVi2Js88fQK3ik1iz8C3YKmYBRYkp3Q/ZIWwtiS8/9rGhO59XwFHi
	8fptzBMYZWYhSc1C0j4LSTuymgWMLKsYRVMLkguKk9JTjfSKE3OLS/PS9ZLzczcxguP2Gc8O
	xjkNFocYBTgYlXh4hfke+AuxJpYVV+YeYpTgYFYS4V31/76/EG9KYmVValF+fFFpTmrxIUZp
	DhYlcd7J1hf8hQTSE0tSs1NTC1KLYLJMHJxSDYwBmzcWsZh0ZEfUq+jdcun+PWWn0mqWV+KL
	infxvr9e9GERv4vovryp//0bYkvZ9beVrnmwQWbNpR9ZrKaLPK/vS6pm9duazm9vuExymtCS
	9cu2uyvU1f05/OaQfo1XcFT13h13NsYunLHb++IR0faZpfNOi7b9jV/5PqD42LotpU+fvb6o
	oGCoxFKckWioxVxUnAgAdMXF6NcCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5J5o98C026124

> OK, I get it.
> Another question, do you guys ever want to add the devfreq governor dynamic change feature?
> 
> I mean we can switch governors for one devfreq driver dynamically in devfreq framework. current framework only supports statically compile the governor and can't change it dynamically. 
> 
> Thanks
> Xiaoguang

Yes, that's on the TODO list.

But, we have done nothing to support it, yet, as you can see in git.infradead.org repository.


Cheers!
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
