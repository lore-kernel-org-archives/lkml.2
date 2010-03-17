Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0CQVnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:43:25 -0400
Received: from web80008.mail.sp1.yahoo.com ([69.147.92.110]:36318 "HELO
	web80008.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751957Ab0CQVnX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:43:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hcC9txBUcMZTshUMEOTEA9vTTGu/rgxl2SXFFyUh6Gi4VJ0nTXiGFUpj0I1OefHXainTAuq57hZhLrDcdC+6oQ7XT/BDKBjyXhI46nHJ0PF4LCIxa2kq70DLniJC+r5VHOnPYJAtNOZDWIcTIyO1xFQ9J8YZYgxZJkypqDf2v9g=;
Message-ID: <974309.47397.qm@web80008.mail.sp1.yahoo.com>
X-YMail-OSG: Xhc9_8gVM1nNfJ8ZOZDXO.oFqgSRu8diJHpIw_aZC2fNcBy
 .LaA1znCRZWiBUuGX9NQQypWtljI7M3IJRdcAoRmazPA1adeilK23qKpQNrc
 ovTBOiIo8zqG96P1.Ndsee0YZft6PgxnrAuqs7NQ3Wj7nf3t6Xbwt_9_mGaS
 G1Y5cD2Jt6lxfs.8MitbXn473G10fOGpfZZDJIgsGs5XmRHmXD4Ri0JkjvRx
 8vmSs9.5vdtRcq3zV3t1Qyjqqt.cRBqx7B8LHHLy49y12jTn.PvYLUcVpTac
 RMKJZb375bUwK_92RQnWG2rX_yrvYcrXFlwnhGEsqMlgWzqgJbxCkZnDPIot
 sut9R0FReycOKy6QjamcpeFh9WvCu5sMn4Vq454Rf.3tsoWeqDd6w8RHXnSC
 _mGL2una6dxP4ifFbcS3GtsaXqq5JacGVDavfJa5527LT_AY.cKfhsy0gHdy
 _twbr6W6LkOBUSFj4PFRfBj74i6jdro7PMr92p47WXNq2LGgIfz5mjW.H_0m
 2.9b9CggZOLuFXQobPq8ivLRF4Yvm1gxwtXVmbFFD.ZYZ5tYnt36dqgonddt
 5upzPI_Z.tlPiGWDUqKLEIFpNICAYVL3Gi.Dke0A7e3yNctA_.4XMDL6eQ5q
 KXH_K.Z5lj38v_CNCkmipTV_OYZvD.r3b_kVXsB43jfGEZFs4NSOEF761YU6
 QTLuKKs_pa8amkpdlOZ4rA2bvdTzWhoIBaPFzJz.K2LLkiNsq7_Jnzem9nOn
 o4XB0HId5WF9P_8F5Llzv9JlCFPzw2T5KsSedl3YFgbMmngIexi4mDZx71tm
 siC6m4.Zn6MkyirdDzTawuCZpd4d4idnD48XEWxpu8Km5rv.QJgWv8mTZvsd
 E20uew59bBbkwtYTRi5PPZYq1keEjDSa9MzNQUrCXZR3P7CK99m7e_MXU9x7
 Jf_f48.K7LKu7sC7HCMVrv08GB0xqPDtwEgJAALeyMg7cl5.OmxSe9Ba5hJP
 W0GJ2NVdKhHrVz.x3kUDJJku7O_DRMWNgdrbhdcrrEx_fJkougrPlTEAVsg5
 lP5SOG_INd3q0W6Tje4QfdTmJ6Zw9ZDAF6fYNbi2ND8mUC.Zy6NTghqvD7XY
 zzFUEOlwK887Su9gh4Ox5HXUtt0_muqpW3toTSK_WKX5l8Xm9iJicd1HbuGT
 NcO_vbrp.ifZvNRsX5KCYaZN7Efp2j54Q0JfuSub5qIHYRz7aEMr0jUKQDXd
 fe.46gDqC1v8NLJq54Y4mAlUaxCmCaf1iEP7na0OQB.eBww5EloJrjOF.xQT
 Rkt0xX1qFiUmOHZ30vWFSnoxCYz5BhFhg.yQI6GYMe.mdYA8YoqdO3HMxehg
 4eMJbUNEykMWB_UZbgjMJghM4WYRdPtkZERPWHk3kuooaQwnN9Wt1UFGe_Nk
 3IHANwHqd1cZHwDN3ZPv7rcT6Qwv4YWjehVqiRj4jg_Hx62lJ5NVltctoyWJ
 mvfIyept2EJzyQkAR3ilM5Rm.DRqmOwxNE_A0GZ2YypxiW9PKh7.zHiIH4o5
 R9EbiW33qh9e7hzsVWoCX_6pMVKI2nUH0QU.ldDypc.wEqk6no9bDEDjet1U
 gc15PnLG6PGMDtV50WZtHidyyn0eeHxAASRiN7aWS_Jha3GTz6Rhn5s5YG0w
 dzkGHcRJNG21MaMuBpK9qZQ.JcV8is4ga0ruMe3lQj.CCcQtg5pEmvHW6BoE
 _S1leZhAGl4q3kB72aoCGmkKvsSZv3vnZJpno2tcyjTNmw_fSbNuNBggWcts
 k0ikd3c3eUG6U5cl_5G8sJalEgnV1YIfdAfyUQ5k1ho.mHdVOTT0cDccUe7_
 64BQyXxQ8JmUzySFAM79mZddttWropcOUFMe4Jz0zWnwLPcica4kgLBGUqsr
 4waW1wjIdNzEwkQDkZYRR6sIXtzNRwEO4hto-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 17 Mar 2010 14:43:22 -0700 (PDT)
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
