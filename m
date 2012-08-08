Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab2HHFBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:01:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35166 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2HHFBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:01:20 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-44-5021f29f839d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Dongjin Kim'" <Dongjin.Kim@agreeyamobility.net>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Dongjin Kim'" <tobetter@gmail.com>,
        linux-arm-kernel@lists.infradead.org
References: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
 <1344261462-14183-2-git-send-email-dongjin.kim@agreeyamobility.net>
 <CAK9yfHz_q22JgkULR9V8bR5W_TXVRn5qs5u2MiJJpa-Br_YQUQ@mail.gmail.com>
 <b937n0skj9tqmbg6tctdu48x.1344324481459@email.android.com>
In-reply-to: <b937n0skj9tqmbg6tctdu48x.1344324481459@email.android.com>
Subject: RE: [PATCH] ARM: EXYNOS: Add HDMIPHY I2C adaptor
Date: Wed, 08 Aug 2012 14:01:19 +0900
Message-id: <0a6a01cd7522$d8d75160$8a85f420$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AQHNc9uIoQeukVOAnkKgxs32pAqKQ5dN6/SAgAAIsHmAAWh68A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd35nxQDDLbe5bW4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr488Cl4AV3xfzO/awNjH85uxg5OSQETCS6V61lh7DF
	JC7cW8/WxcjFISQwnVFi4d12dgjnL6NE857ZLCBVbAIaEoffPwNKcHCICMRLPLpqA1LDLHCX
	UWLbowssEA0zmSS2zO5gBWngFHCXuH/qACOILSxgKTH1zjqwdSwCqhIT934EG8orYCtxrOMZ
	lC0o8WPyPTCbWcBA4v2sPlYIW1viybsLrCCLJQTUJR791QUJiwg4Sdyc28UOUSIise/FO8YJ
	jEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKSfSe1gXNlg
	cYhRgINRiYc3KlkxQIg1say4MvcQowQHs5II756DQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
	xt5f/YUE0hNLUrNTUwtSi2CyTBycUg2MSpaioWt8oljU90/6d+C3s57Ji08KPBcvCyjcOvzE
	4u3CnuCgDyf23uPT4Zlz7nnDIS+/zyLv2LXn80rtOr0g+3ELi/G51BMpSTaHVhe1TxU792mr
	95upj9S5ljtNu73zLauaHNvqGX1aPEsvx6lMFJ/smXRu7ceJLxadC4uWUWaa8PzDI5YADSWW
	4oxEQy3mouJEAOmq3oJlAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I applied the patches Sachin pointed out, so we could drop this patch.

Note, Dongjin, please don't use Korean character in your e-mail and keep
the new line for over 80 columns, actually 76 or 78? anyways.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

Dongjin Kim wrote:
> 
> Hi Sachin,
> 
> Thanks for your feedback, I couldnt find the patch series eariler. ;)
> 
> Regards,
> Dongjin.
> 
> Sent from Moxier Mail
> (http://www.moxier.com)
> 
> 
> ----- 원본 메시지 -----
> 보낸 사람:Sachin Kamat <sachin.kamat@linaro.org> 받는 사람:Dongjin Kim
> <tobetter@gmail.com> 참조:Dongjin Kim <Dongjin.Kim@agreeyamobility.net>,
> Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
> Russell King <linux@arm.linux.org.uk>, "linux-arm-
> kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
> "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>,
> "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org> 보낸
시간:2012.
> 8. 7. 3:57 오후
> 제목:Re: [PATCH] ARM: EXYNOS: Add HDMIPHY I2C adaptor
> 
> 
> 
> Hi Dongjin,
> 
> A patch series to add HDMI platform data support is already under
> consideration.
> 
> http://comments.gmane.org/gmane.linux.kernel.samsung-soc/11352
> 
[...]

