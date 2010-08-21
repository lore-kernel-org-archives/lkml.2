Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0HULpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 07:45:03 -0400
Received: from web81705.mail.mud.yahoo.com ([68.142.199.169]:41167 "HELO
	web81705.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751160Ab0HULpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 07:45:00 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Aug 2010 07:45:00 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=MXZJCDaIhEnDOZELD2a+1J0k2KOFLyAxxHWlKY0yVEcqL+PHY1mCWQuObLsEOl6yi29i4ewUtI1CBb7slP/Qz7lo6A3wfHpxGgtwijX0EascBQHzkxsHQbE5A1rSskJFHzZbkPMR55I0JSTEFfyaMzqMrTNLvkZCWz0kGWfT6vQ=;
Message-ID: <795443.313.qm@web81705.mail.mud.yahoo.com>
X-YMail-OSG: NEqlV3IVM1nBCRoNtj6D.efq9YvROtgZ8qvgk1_ycM7l0e7
 UuS6MnwueDIwSN.Xm45Uqc4Lqtu5bpem7gBJUeIdLnmWp1Hqr12jOF2VqYGx
 f.y0oPuC_5QgxV5aaEG4dA46As66jYHtBeWzuLisS.gKj0FPWaw4SXTlMu38
 Gp.nVQpi9va4BfoSx6FGFE3N0.5gVCPU0p8HiwSVmjm44Bn63W8J3jsLJS7K
 BCJrBHN0jQ6ykvAaXA8ty53ua9LlGpaIOzR4BiQmkqI_G4wRx1lqoRxPVp0d
 Lbt3TbOzRDa6NwzM8hsN3DY5VQ5KkGaTMzIT4W3COAqWsC1nhY6tljXXsVNg
 X.9TSkgy1BDJHT6C1952bKlVLgUL8EtHI9uXnqXtxsmniM88O0ZXBS08nofV
 xVoL4LIgLng3tJ0mgFB0kMAT.4ne2deTaY9GZ5xRpgs0s_qonn4Bf_6INv8Q
 jQzGY_Lzfq0SDOTXBJrzJAVs3V4WwBqX9TQYFdEfvsPCUiVukZ1X1T87A7XT
 Kd.MBBwaX9Hl911BUcgAlBM49ov4a7ydcdbMluGYpK1_Lh6lb4l_cC.mOtyd
 gJz2XFvP1VftzQ9IanJdk9_GCGuM.Tai5LF9NGuQQw8irNrGd_kSDxfCwBwC
 MibLnrNoaoBSDL7mb9DdVwzagE9cGz_6.oroxk_EpJSbWlVTg6lEuScgxyYB
 hBU9jcJ1qIb6YUYGaiU.EpaeVQSnVKvcK4mWxywsQK38dn5nvK3VF964CufL
 VrNXbtHH0tR3NlKMdobIBzibBG1Zrr1f_Z_ar4STy_CGxoeARiD.qcJ50ih7
 U4QcQWAL3gXti9.nBKzz3xuWzflM0Eoag3nzuXxHD2H6ZCOcb.Z4v62mE7Z6
 HWaYW5SOdPcpveWZRXBW3EgwfCEzEFxt3WLhDr4fDAL2wzkN7OwGoJ8fvSoq
 kvECyBNB5dq8IheVdWy7VaQtjRqUGaFgYhvUx5uRyySfUssCpNOcrOwdLd_r
 4Kkax2q_egST3z6RbwGcgbyOel7RO0tYBMu9_zRyqvXw.8UtwP2A9W3.qI13
 z9CdTFJ_HmD1eKtSiaeWomjO9Ko2EkZ7Micu6yPEEUUjMqRUMFgr4qM2tl58
 LmbWzscVNqDM7kdLoez8ErMLqw8G4YZ8K0KcZedRud49ughDt_YbmWH1O_Le
 9l4gFwU2ZeunbuUT.zSjxhVI9EafMy3WFUaV5YgqTxbW2N3hCRx8CToqUr54
 C5jKwFgkZ_HVE7DNIR.jmcvxJpnvHP018u6oEcrf4TKCN4r.V9Q9hyeV5xlh
 Q5gjeQFwQusMhuCwiRhpVAOsLblaVR413LHnkLa8IziZhaLy8xCsK2J0QvHA
 2qyiO4qvweGhFdeea_UarxFWUgAGiq_K0YAJ1MvsWPCXlhW.Y9Bg.QhgcULS
 QesgA_WvhD05rCRLI9ew2yep9cs7xqvbxmZ822t3c8LMlpJIyUAhsPrn9y6C
 5c1xIrpmmpH5WnoXCvg9vgenOWYazUsnNrlCEjzTXbfGwQBizbW7rT8VwSlx
 7TrnJNBLyQS7UCVI7zz0n1kmRLob2oj01hwh1xloKSlFrrl7rmcSAFsLQB8g
 3U7hGQ24MZwHbJsoEGG5TqOUjuilM2VLPCjwHm89iaW9RJy1pTlzj8bHzaL6
 g4k9U5sk5UQ7UjzFx7lZP5ruA5u6lKfB7lSiRWqRKrc3MK1kMml_hFWh0Qjs
 lFrH87ls0pEUK9q.pb1_SEddkWvou8O5DE8qqnQiUH7CKuN.ZPkWlDD5xJ44
 ZHfpPd3Weodz1gDU53mOCvZt5TkRzDU_u6f.p8KLXxtwfdc4hc0x.woqStwj
 jiE_67BkrCxi4YfHWoTLJ3RWvtsJVpSmw3J2_yxkQZ3.__TrxjwqI0JCUGP4
 b_TttIEyo5IT.aEwUtVzO3XB4SD0GjaHb5mXRDR6vkYvMi0J5PnG3kh1Tx7f
 E0.yKhbc.c69TPbgQtS1S2ywFaqHUr2Ld27cnbyLcjmN7Z2OadwscBEMxoOV
 ag7puIU02Wt1HLJLGDJoDJfTdQxkNyFZQWuXgKBkaw_mvKelMXPLGAvTkLlw
 iv0PkQ5V9Y4EVmPu2STEEd3v4beh87t6VHJV9Jlf_qbdoHgC5Ron3t2IPz_Z
 k8ybeolMDXCorUEVRDjJCR.i7RS0pgt4hnVfvEAtEtQUbZhm0FvfQWo7WSb7
 xiYnofHaibeBw95CoPAnG2TRpSwahPFHWpnPtfwHZgCu8wd0LRxr7cmPTuD0
 .FZP6aMkmQ_Uxcrk8ZbdkVdSxGAGys1BApyP7pILPoFrE4z8nsv4tx8rnHoZ
 Gv3yiqwrJkjoJ_Xxhu8TmQPGAB1DWtxWwFuI4w7aG85KMZWEreXXWzPBIVSR
 3TSGTWwoM76MqiUG2RDGGpRazweEXDC4IWVC65QbP1i3Dv.MeXkC1QBUb0j1
 2tkpgmY.dPKmQ0gDw7I9wpzVGqqczm1QEuypPfkPHvHUGXSiZgcI6F478VV0
 idl5ySDOaZo.TuUoKQ6qRNUWkCEdazbBpPq7FNNPLMFZKtGlR0x14fSjCkaG
 aZ0RyghCY.MPQRX9XP06QAIksHXKe15FV0DAzEapRHxVjXYWQ6bNW9fv.N.r
 CZr_LbD6cOAZGNTQGIlXVSqil1dFS0BEmaKAjhgZEKAT1Dy76ujExzZGZ_0b
 ReD3L4wlTe0vqlOu729D37vRJFrzuHCG5Re2YMTiuMYYSSF14SkVYBRzxrpr
 EYJ_OO1YWku7IcqUoPxjebk1WTMZ0dTjSyT1wYaY2Ss8ZKq3xnCwgCvTLPUd
 oZMn2fLzC2IiuX8ZP53XLSwm8lwXkcPBYbqILN9QmCzfyH81cnnPT9tbyua8
 NoIyL5TFrUcwUbTn7fEN2gP.Q0xqqCghMd0ne_D8EKSUM7dnY2GXWPUf4Pov
 NvFZk1PZuDdGPVNYiI7IuS2ww1uv61yNrbH12nA8zwGIYOpxzBzjxZLVcirc
 0wLKZ1dEOc4Pt0isUyFAJm3R8JSlVZVdzA6NUWUw9fV1taBrLngjuYeI4cab
 aPZAYNM6rUmf7nnvkp7ynZ9dQDKDAHfEQLrCqiB8i8qq8qjojkWiNxCfNKXc
 97zMPZOQ6M1.mpNRawpcvVh7epn_mC09b61sSaEeaSvRPs03Hn7XHjKAI4XO
 5m30ZKgjIaYw4ABaTHOiUjk05WwJR1.qI82feej3B3Kpbs_.UBrzsUFF0CW3
 o2okkHvU6G.rUeudJIlRq17Bb6IHowsM4nuDdcBHcDgUYu55UMDtJzzhqNIq
 b8LQHk4ojWm_brEuBMmPG43uTLNXEI64.LUKQaD0FRRNeTPMEbp.Kiix2ge6
 Bo4CXF3ZqfG1C.Zx77IvOgZTJLcGHR07kbbQ1lH_FrSeR0QHxTl9SRPCJubB
 xy8CkHSK32HJCLYUy3zSTf7GgAJM8rVIl8T5hCF0_W9BuWyI19UDJ_6zfapi
 g7jp4X3O.g4tbXgql3qL4Jp8W4Dehic8qlBWrIsiloXlzR3ir0hXkGlqEGTd
 ninAdrNrVisgOSCcHU1BsNsZhchx.gWTfhmMsRRBwtsxuKP_a_dGK_rZ8xWu
 4t3y9mY0F2vCnXhAIh.IY2_GGI3DISkdAy4Fi_QlA9HcAw2_bkinPAU490BD
 XgRs0YsznXLPUk8gGw0rPzhy8jybxuQtGcsGuRx_08Si75b.s.Wt6km26TW4
 Zry6pllOVoBXWbQDr2qRx7mBV.quoFZIMM3cldMP89lYk3VJZnv7SlGo5ov5
 Ya6_uA_kXSbWja3ibRQRE5eF_6b4BiMK0Bd81gbeje2o824tjDv09yPPN0vR
 YqazX7sHAVEUuMJbwgPLRJurICsyhTSnwi1lrnWp1goA4kFpzomDw4X2VvpQ
 .RjTeaz34adw3KDHnfonhGa8BGYj5BZSCfFy8wDpwa1qNOgrqUpe2OyT88tu
 7i.0VqazinMazyF4D5bJzRKNRWnTDDIh.gomJv86xXU7IbdV886UYdMy.JFW
 B5bDX0Oj10y8sw_V1eK95cZPPyyqnc2eJQqf_dn2ylK2Uea7RpyzPqo3iRdZ
 0aC30kEanFLqQuoE6y38jWkJDiPjGcnyFkq9RZ0CnjJwyuPwZsDFOkjy5jiJ
 iy_M669u2pzaGtfG6FYTDci8fK2uNDhXqhLhIaORBePC3tu4gm9pBR5NhFrr
 ZGbITd2yhRKRLNP2s4cQkB5kqMfToPPSeIw5jzuQXOjcywRTmkrotpJH5LEy
 Uc_1yQgzsoAQqPdW_2hnoWjGPab3PDD_8acBQ7XYL8hPl6gT2zoAFPE.45PZ
 kyXYG9WJUelUrlwWEA.rNSQMKPtcPMBxe3yzWVohwkLgXKHgfsSGhzXsc6HI
 Uyx7RUsHkrbygo49GMuLIH1dKkKp2NWkXdNDsHAgCUlYlaj__wqv50CyMV4v
 dTnjT18Bi20wRKE5rIi_XBCRI2Wo8_LJUukgKOH1CBdkbt3yVlsC08tnN62i
 OnlnHEj.NzG4QI3cApESSVCZxYHsFnfwFfO3x_iPWP2E8e.m3sGv8QY6VspX
 YXd1hwst.1hFL39GzGUkij2zHgcbosYFaCTiJzcnmUWad36cYylMunJNC02F
 i3560tXdRK5BOl1vnIa1h2CqKHW9RvNyI7piE3t8wJMr65k3rVmdTgCcp6rW
 anQeeluFFi9R18S9LET.XnHiIj.P6XHOsPTK2BRMHjbi9umydSp19A6pyZmP
 vWnHsmi25lku8MgWvwNvh8y81FCbnr3ZaD3QDL05XkSiIzq9kKC76Y0k2aMa
 bYHNTh_ZTB2g4qvVEamEn1._9F15hwUe.nK8VOHwUc4Y-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 21 Aug 2010 04:38:20 -0700 (PDT)
From: Account De-activation Department <daniel-patricia@sbcglobal.net>
Reply-To: upgradewebmail@webname.com
Subject: Dear E-mail Account Owner,
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear E-mail Account Owner,

This message is from Web-mail IT Service messaging center to all
subscribers/web-mail users. We are currently upgrading our data
base and e-mail center due to an unusual activities
identified in our email system. We are deleting all unused Web-mail
Accounts. You are required to verify your web-mail account by
confirming your Web-mail identity. This will prevent your Web-mail
account from been closed during this exercise.

In order to confirm your Web-Mail identity, you are to
provide the
following data;

First Name:      
Last Name:  
User-name/ID:
Password:
Confirm Password:
Date of Birth:

*Important*
Please provide all these information completely and correctly
otherwise due to security reasons we may have to close your
account temporarily.

We have been sending this notice to all our email account owners
and this is the last notice/verification exercise.

We thank you for your prompt attention to this matter. Please
understand that this is a security measure intended to help protect
you and your Web-mail Account. We apologies for any inconvenience.

Regards,
IT Service.
