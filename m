Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0CQVoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:44:07 -0400
Received: from web80014.mail.sp1.yahoo.com ([69.147.92.122]:32293 "HELO
	web80014.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753607Ab0CQVoE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:44:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VeiZxpyFB8kYCpBdUznNq5422We7fv3+MDttitRfdTL4KlmfHEh86+a2f8UJ3M9glr9MunUrTR26NWZkjI5w2SGiPJLp4jJtoORzneVGPmbwc+vupowv6xDZ3uf1lsm9UZ1ArdhzjiY7O3tNPt1yhrNJRmu0xxWu/1w3BmhXwvQ=;
Message-ID: <81026.86332.qm@web80014.mail.sp1.yahoo.com>
X-YMail-OSG: 2_R0XPoVM1lLROWyUEPbaFLehjaGrXqUK30u8A28D8j5C3p
 fNdlErD813MbWn45n7xW7wSz7vxjX8lcEvGdfdrvHVxt16pXYkXlvvXU2yRQ
 JQmbGioW8_Jxso16PHtWcK4d.FLsZTJayx2djwnuA6aq3hTLZFbzU2BtG5gO
 AfgadvUuhhFhp3R7gmUZctgOLDbP0SMmzju4uh9aoXyv5iKxIMmxhgHKc071
 op703kZDbFxqglv843OtzeKN0GSjcuURuqp5JSLkufVywhnbWIkZXYIhdzZx
 KedfAvv6gaiSE7rQ7h2tt42DoLBlYQAnktULD38Hkm.EK0vssCdpQfOQOkOo
 YWxb1dq7coGJOTQaj_zXkNaTVVcuR4uxT4Bdj4pYoEWhy_0qMVQV3437kEx7
 9Z0hxmdKC5K8ECFr1baMKUJJkyaxkkWCNxiKqpv6tgaKPE9bADcZGj4jfqNL
 k8UUn79bt_hLoafTyVLc7L3cnP7s0oxX3rAbX3tXKYLDm854SqcMZ9hudrrp
 F8WmbVS4p94haOu.NV1jmhC14FnTeFl4mdvadRJEepWoupf7EPBFtAgDIu7C
 SmB4OGmhcjPw8GbF0VV.zXHkBFXZHfYG4jdd.CNQSlyKQBmkrrmjlaWr.194
 zuDthY9Q71Yf4yO0aqcqr75b11vb0pbSlsjrOAHD4X6oAZ4CLCJbWXXhOoT3
 lSxZamL8yrhIRld7F0kviGEiecL.vvpM682htV.xkPPDNl3igOVxeaOm37RB
 Hu9hPkZ08IlJAsNX1aaHw7xBAX51hnIK8fazlmrFbX8.BeQi4cYQOCjvK0jL
 HI0fqNsIvOZRVIHuNKGSbxhe9vzbUaG8Awu0WOH2BjsXKc24RQWRgEtuis8Z
 cQGMksPviXG0tm_fE5gY1NkXsjKqxPiA34_Vqw7IDZaeuBCfomI8tvMyJhsx
 ShJfWDyVnjfBQXn_VFrXXXgDDdPsCnnflV7ozLk0CUFXvasm85dyk.WqOkZN
 Qbcgu0SqMj3x1tJ6aXND9foccRVvnV9MKiPZYZoNb2IanQkNshiNCJi8iR6n
 rGiRL4ehNIXGW6wZKpKVED76TdLXjrWqUinQaA3W3wDgTim6E3prcPfC5VDT
 Rpi073hY8onynhvs.6ad.EuNB.lojaEciKDy_1Nfhu6D3yw_cPxKYCkYRcWJ
 V6zMh.r2B3bWIk5ItZg_RlN_e4.wWBVbIJLfVXpFLPrGIhUU8ZiMjDyeCwgC
 Ia7R7IOef6YoRTr2rwQEokesYf3tgXGhOGtPJP8QCc5M0GIAXqAD7K7Dow68
 PcIrdQBNazg5lZe0LweXcfHH5tOX_iAmQT7pXUN2wvTvxUPUT6I0qSoSGqgi
 K6zTZWrevRI54E2nPNE172mRtmiMdIHyqcL5YNhI3dpvFnCFfolFGI1Xbgeg
 YQQJBu84VJxP6Qgfo939Nnr0D2uQuHVjPKSKNKELYnZwSiwEYOBHydrhG0w2
 1UoC3e57PkEOSU5bjxmtiLlspJhsxefdR9WSo0mT3FDOhICRMZIx8ReiRYef
 lCM44G7LfEjzOOvZSIbOF69u1HC2yURb3hSmByKy_BO27D95l6FWmfVjEHXQ
 SmsxZBGz3JfkpT7TSFKYxbuvhqncGBl4.4fpruHfItGGqeeONpCUi8NJ0J2h
 r3e5MwJKzQxekuKPtZ5rz.nK0qG3ny0crFS3QcO7IRf1g6AWc4TuAbjO4Z43
 uoxysr3Pl75me20aDh2GieXXixU.lMYZrChUv7r.V7RvFLil.xw515U9f6kJ
 ottxUh0GHJWY472hkKSRTAiYU114DZVk8f_6_ZXKBwxWDhuy6BF4ipEUDo38
 4FG2lUoWfUrYrD7pSJy6k_ebzHQqWEt0iG8Ugp.pau6tJk1EtovhMVA26hda
 FwUSl1iwlF.l7BIFLxPzUwyT6fXhKfVA2hfhIKkJwjJOfChK0tiSVicKlPtq
 Up0BANDpfWwKXai8qvodbSxptTRiro9whRbF_GDZzXLyCNaVaHd4LWKpe36u
 6I1NzFnqMNpUOTkwHpkmhYS3nwm8AmMJyX7CN2ZLn.f4AQVXWtJLk8V3E30R
 HTX3mAaRoK5E9eX3sAXfKt0DCTEFzsdFO0veZ67DQSW4_VgOQ7cItUPDBXNi
 m27e65v8tycbgLdisU79qN62aEc6MmTt3SeXT01QdjcQfvdMDfTv8jr1notS
 nSftk38iF6nbRkcVf.Ec7_Gh4N7cJ7rkXMPy1w97YLbKBfHguk7vW_Nksnw-
 -
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 17 Mar 2010 14:37:21 -0700 (PDT)
From: Irish Online Promo <tassajaradude@sbcglobal.net>
Reply-To: irsb.claimsp@9.cn
Subject: Info
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your email have won £891,934.00 Send:Name,Age, Address, Tel,Country
