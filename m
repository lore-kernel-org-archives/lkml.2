Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab0ELTwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:52:15 -0400
Received: from web82307.mail.mud.yahoo.com ([209.191.85.227]:48253 "HELO
	web82307.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754769Ab0ELTwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:52:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:To:MIME-Version:Content-Type;
  b=xgWH/X+Bu8tnBXlpMF2evMMRWWpX+Iztyb6GTijD+uNafddNA/zGdRA+kHV8vpcbkxOmUy/iHZmy51VPnYAT5dXiYBuO0Ok0vTQZ04qsThNLmNoW7+29SjAH2rM1d2oxZn22L/gAjO57R1id1DWmBf92bpZjfMbgPU6v5M3mnK8=;
Message-ID: <301502.66208.qm@web82307.mail.mud.yahoo.com>
X-YMail-OSG: qTSZ3OAVM1kgenIcaqmnI_5TBNIyRL7DbV9NYqwyWXmjntX
 9oGhPCkU2YlSAMhu3oonOdfhZ3Ync3qVVhaCf8jC9y_pZtV4Wm_e.hfX1tDs
 bSPBozI44l96IsaVxzCuJ1r2v01V6SkLpieQFjVbR4PWj0TGMXAo5DVDmgsy
 lJJWJIZGqc6.2ae0oXtpF51dtrb8BN3hyMCTctWxfQ_p5L0nTBukJqrEFOLb
 gZL5P6RsgHSB0ccdod3Xz1lUCZBLpbR_LXL5FPBNcSphv48f2cDCbiw91jRY
 9N2s1qxqegoL.Vmi76_JlZ8FTRrK1uvhluzLTxeXE.Qio._Cctnr4kE49TdQ
 4ED0dBk0XpZFGkHjgWNSXX9kJO8reihdwcKFciznoPkLUiGI_R99Dh3yTOFI
 mgLX2SeBiU__WUYuL3YJ3dryLG2GzN14CprlMP8E55c79eE9LYgvpG.fHaBv
 kqNPCynayKRtLcAbW0b9DNdV5LL1nhoRieYeK585mXfts517fGgtMvMVtETJ
 MCQjaj4mvotV6mUIfTvs8S5IrevHBq8Q8knLh6Z6epNc4NvXtVeEAQu.VrQL
 pqaLZzuiAMYTHRBFk7i2q8.9Ri1GeMJJTMsmoIzUx_FJgzE9GPp_oBuIrBCx
 cJQhBIbhJbxYRwJqG2QBaqLIqeYEPiLk1pgzQ0Mc_yiEUo1RqtFEp915SOIm
 nVDAcWPckmZ0IvBKl39FU_yP_l0rDkgScfYS3AxYqqSMgneysNqFM4EsVxfC
 RfyqMhPEXLQqzu8gzOavwuBbyhzCvnu3._euiVUpS6yuht1K5J1WfNys6_4P
 PmXvTLr_FOKvfzxxGIZEV6Av_GXYUDVC.bPN3WuG2XiviER_V6zDMLvKdohU
 87.g623.2LplmSi8vWTigjzObfPaoQE1NyVxJlX41w72_pmU7VBsslGxjnnl
 fDm35tbwBcVUHZ28FLnEMT7AHQwN3BX1UvebK8CaMGxfEXoyORpJ5iC.wFIP
 fUN.aDPATb.StP5acss3EeviwrC1vsZr8jummGXxQC3TGla83rR1VnRe4FAu
 NY7NIBj_eLWJcZ.keuNmoB75HYmlRf9LXpSYwwbCC99WgBmU14tpfhJn_0hR
 cAR7AC6t2MGNeh91.7uiIrCz89B6w9CNi7dc5D2HoMBRIYOMdovSQTowb1pM
 OwiV4kVxAGHCYN._HgJSNBU3OSwptZiea7y7ix2yHDLts3S.4gijXzsaDmAF
 .6Mg9YkFpuqcg2nAquDGpsK8HX0Th3nIN1ggddO795qK1koiBoPcBG_5Rqp.
 chshIWEtmz6BAwDMDHCpW_J__cz4AIx6sAl2NU_2_gP2SsvQV7zq1SWNCRJt
 BHIrngxVEyJQf5.Pc4eURrxrQgG7fbdcX2JkxktY8BAI5V51QTtLWIaAzivL
 LpxyHO4b7Z8mZdw6s8lQRsNI6enKGKN0BaBrZLhMiOZosx2NENifg8Vk6xCg
 MUa.UIpiXdX9GYrGgbfNSMMIU6AxLZ3DTpoqpr_utoWB6C1JuRK1tT_.HPnG
 Bgbm2jjep18w4hdetTGHN8o7VeEirJaTbGSfqqJfjoWo1gIk.az7E93grB6.
 hvOt.sZGwTaxX1A_Cr6iSz__9mrHkK9zRyVZZdJy6.nxeVRCK1qqEI7uzHak
 S_WdxLvtB9HkA5k8gy8uq4KVXFJz_9pIURbUz7nxddM3m5NZzNTsX4nOZG9o
 JAL8iYNEYLdSP2HDOX4QqRhdanBUrfE4W1H1nghWJb2KjST.G44uk1Ps3FO4
 FtNAJEWzI.PO.UX2gFfU8l0wg.WjRYeaWY2nCxKktbewh3LRPn.tyK_Lq_Zp
 .ln.NZtTbYtJAOeJ43cXc_qnfMLXbvNyaq_J52jL4onnbxgxRY5uVcC2XyTe
 Giyyv5NJjIJyoZABSM53LAuZvSnY4pZV0Uakew.8FijfLWWZOHU9CziOtnih
 SuZFje22CL1GzRFh_0drhQOmWtpEjJHKjTgiODJiSDesl6_AwEogRNgDvDFX
 I21Dk0zr81byfEy_x1ks1cqFbTDKWMz7CBtz6.RK4jGo1nuf309PF.ASGJ2a
 gWkwCp597qk2BhMsgAQgl0OGSBsJqRaoE3olPHvkVi6wVV1N8jV_mfxMlTYd
 cDrEU9fFpV9EOrRgxFK1wyPutmh1Zcdoxve_kwVQt_Y.e8sD4_sqIsqhPlQC
 2eWDhNTvOymlQ9udFg49haky0kocvZ8SY6FF8qg3XmTm0UAbLUb7vsy7YevS
 g9QDiKeWM2b8uARyLttnoWTeyRCWYB3kJr6fqfUX35Q--
X-Mailer: YahooMailClassic/10.1.11 YahooMailWebService/0.8.103.269680
Date: Wed, 12 May 2010 12:52:11 -0700 (PDT)
From: Eric Christon <echriston-ies@sbcglobal.net>
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1,000,000.00 Pounds has been Awarded to your E-mail ID in our Tobacco Promo. Send: 
1.Name in full
2.Address 
3.Age 
4.Sex
