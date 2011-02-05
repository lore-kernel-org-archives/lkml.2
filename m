Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1BEMDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 07:03:39 -0500
Received: from web82201.mail.mud.yahoo.com ([209.191.86.96]:25301 "HELO
	web82201.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751080Ab1BEMDh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 07:03:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ApvCx00S9foBFQryKe8547NHczPLmNWrRITixE25QMngUdIGizkybgf8TDuy0VhHrx8jyvQYBw8wktatIlyIJlI8doU474Zr13CSC6/5kcVt1o5AxE1wHL2gY/FbTpqvMm36dnSouqbj9k2pEZFjzmSBV8Hym4IqWoOdnXNbd8k=;
Message-ID: <649684.38985.qm@web82201.mail.mud.yahoo.com>
X-YMail-OSG: RrFOOnIVM1kIKYvhaucapf0ITRRw7oN8AjHZNqwbVw3fnHN
 W2.i3gd4o2BqDgqeobaMmLfj3CrGCycpL3IQFEse1E8iilrQvpt3GKZnO3o1
 6QGoDIJ_gsxNVrP4Jv8Jh2GpUuatjBzM7CJcDD1C5M1zxeC.iVRyLsxjpkII
 Jd6DOMJeziYDGYiAtO7cmRXhQHI8LozW82Ct9dUB2VoG4ETEM88xOEY.R2H6
 Z8w1sylCUkKzEsC3TtssHgGnGPLPyfDfQqqsJDH6RK8Uy17r.HLI6__gkFL_
 3SfNNYqzQdRPXVDkseRXDcz1_7zY8Ms5V5Y0PsF.Im6SJx.6MCwitqCKZkzX
 f4y3WYrVKrdbv8PJLNOSxuz_cIdzLjrOGXURJVnZRLZAYHBPJwdvJ8tv24nS
 e2ycT0CmT6VkHITZk4FR16mnhnobJaMe_QnY1prW1xFBE83drHxyCZnDy8Te
 J648qZKyA3EbvyJ.0LyLYStMzsSCBYKNB_cuUjzBk_b5.3YrAr_UcjxO0KwI
 i4Hlxx_K92QJ87tc06GKtZ6hhaKZ_oJ5w5ZDpD0fCwEQPA0yWm.byTsW5AZE
 YNnK557N5QxPeU2Ah5Wxi_S8NTVfEW7us3oyGpeLqmssJG2NPQy_hi9gGQYK
 faK_Yt2yBkGP8Zfz.ighEnYNpf_z35F._GrcLO8XF5KOBpNPfCx5tgppp6SZ
 .JgkZW0Tgccw51meziiX.v9Bgz8PqAYzYwjKxWHoLfoIWqIwk5l4kycsBklH
 nkHZyVqhK98kivPd30hA2j8gNUbYKo7JPMj6pCVWUztCfOANhdXBYCgku69Q
 h0_zV3LRM5UtLAUt5wHyQ4WEp0Cg5xWy.oBni4JtmL9SgUnwfqKpfXM4Y162
 3vFUfmOpG6SUGvkoE17E.wERTmErXgB1YirrfYzNwxfEiLuBr.MYzZqzmbtT
 vDBo0bwJHSBTi8VMI5yvR_iZr7JfcgdNTLWFZU3pM0ee_BbmxuY3XjrrcbiY
 M.b3KsFkHlK.H0P6lSnv9BOoft7BkYgTmmJlqqo4LByFQUhbjw1ZavJs6RUv
 J3tkSxcinMX4AquSJTqijQreffLfELuMiyQdj8xRswJRHwAI9tffW7n3Jah_
 yVoOtawwMwr6i1oHfIs_LDQz8fFKZm8J.gKIJZbZyjNSWS.sdiyuO9ZVS6NZ
 96Lg7CL3Za9R6xWV.fPvsD5wXc87gcOt4URNE.Xgh7w6RvMT0AxqMsNSTydf
 S22KY4U65EzqPLSspw9B5A2MmZ6t7G51WpzXvNZXX8TOKnvSO5hceyH8ZNWz
 wOoKM_iRTP6wopE1fcvIaBmqnZ9QUXyAFkcf4LhE3Ud03kcUpwtRFNNYtLRp
 9raiqwMah.dGV9CmH60M9bmiKBVQzF7SV_Z0iSEXnSHv_vFopUreNzKnO93b
 cJNVXDA0pGjfXYai5RLeGGAMA2JX90zFp3MOd9brWFftvv6VbDGlMx6avRFh
 fNBFvzhAEVO58kTmu.WWARXaSueb7OZ1pHyPyNB1wRcgTnZMPU2OcjtwGnxG
 P0JSJYqWnzgQzvtCkHTgjMmoM5FE4OTu5HWnCwTMfKNulKfQwhp6czJnYEEm
 wo4zf_R5bBGZePNI_wBPafcmlivmtosMizSqRsedCIJnKXiho3T100Wq4XJu
 89COJlNdxm0FaYXpMWIB_Jsh7LG50Y6UzAPwHJvBZZzxueU_TzyT5ZZGf36k
 _5R9LJONFLhsuy7weSKhRnbC.Y20uRO1spyP9LTWGTYsSkW5kRjaBvdVozs6
 ufd1Bya91SQ8P_Mx1k1LIs.ueKjkwjJsxijMgTCtd1PzjI_.R7avjnUfxHYh
 2laAhCEM4mHLCXcAPql5RBA--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Sat, 5 Feb 2011 04:03:36 -0800 (PST)
From: ben-morris@sbcglobal.net
Subject: =?iso-8859-1?Q?Claim_=A3750=2E000=2E00_GBP_IN_British_AT=26T_Promo=2E_Sen?=
 =?iso-8859-1?Q?d=3A?=
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CLAIMS PROCESSING FORM:
Names:

Location:

Tel:
