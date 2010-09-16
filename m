Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0IPN7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:59:43 -0400
Received: from web82705.mail.mud.yahoo.com ([68.142.201.86]:30577 "HELO
	web82705.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754029Ab0IPN7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:59:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:To:MIME-Version:Content-Type;
  b=piAEJ9hF55xkg5HSCCBR+vPINBHmE5NAUXu2bhYiN0AQKY6DSrQSI6LA+BSee62882EwgQzJ/fYiis4VjuuhNCRF35Hvhc1WnmyLUOSwPOyMobjyIkRTfg7Y85MOKE5B/+mnLcG6usb9ZyJeoJGRGYJt7zr28+tIUcxhXslO/ug=;
Message-ID: <601929.31610.qm@web82705.mail.mud.yahoo.com>
X-YMail-OSG: 4hZKCvEVM1kcwnZU5tBlZwP6gmTlEVynlJny6xO9x2nE4b5
 VX3jJoysh4FnnUjqkd929yBxkEGzr52T7wxJzYckrJ3FFioNlx.Q_7LtHY96
 P07IVy4yPRtTS4tvWZDIlGrRMJcgMgAPK4avdbuW2lNeTzrouJ63_oESDsFT
 CtbRjzwD5umS5nXar__FPzVCp.3GDfouUeLgF4qiZsEGGp8V0lBgo3bZEmhY
 9zOAy12Z0zR3ZP2OaqqFKSIYi2nS7jmpRnefHseIh3ugLY2UXhElOsATn9d_
 .pja0VopjpFC7bddRGXnQCmAZZ5XjaxcTTOszuxHsLbNp00OVhnAXj.bof4s
 81s3e3rPpA_5FpvWx46mrrKY7Cd6oKo1n5mTWvlf2bnopNtcu1Up1B7l2.yv
 iOUrJJ7MuXGEKn9raAirpuK2Ge9rcd6dqOPIkRrXVi99a0iIgpUaq3XVI3in
 972ZxpsEgQHY5r5o.rpTtOqk_uzFQocBdHMhnP455LUeKrhtum_OzZ2oS0in
 BAvEmUoAdV2Dfp_1sCdUhplxZtlbIcrPyAfWqEGpsFzMNH6H.l5Qdrjq3PPY
 iL04cUVv0QhAHl0UV5Cuaffkr72OO6grKX_qOwyQYaBCt05VFo3UIH4WU_lq
 ydM2mNMuggkzVk849Rs9X3MKaj5C4Js5Fm2svrogfg83u1jFu5wo6g1GMm39
 xv249Lg.HVLEPhb0cxRVICmQfQJJw2hXjcBZziVxmvG.Gy1c9Qh6NcBfH02v
 ROT8mHVL0LtT1YJrJn9KZq_5CCXjybdJW5leM7Ow9obm6nIJ.4.t74yjZHuw
 CNzCbHNi3gnFyARz836ZGo_.NesbAH6m_iXPKcsrUJJXVWwGMjtQefCgGBIj
 NiiwYOBy6sqy24e67_9Sh3jZ74DUYDsFycKJPn20Ph682ZnM0bZonzWxIrue
 DJ2d2is05G7InZVBOLMt6tnOWs5PpE3Qx7pZoxbgHB.4d5gaGbHjuOfn_Pmn
 56_lrlq400Z5_yQwAYr_7Y_9Qz6WIXa6_MJlwxwWUJsj0HQdl4caJ8ODZ9bL
 AmyKfLycCarTRDEKs9mjQsj84Ikpg1ai8uPIgSAjEpCNZDrTS4dlRIU1wPPJ
 wGVPZKNMVEm6Vsx2uKbwTR19Ql9yUMF22_Y92EiPhNa88oMhc.RB7Oz4lt4F
 JMK0zAAPsngZWvB7QVcFvuz34s4qcCOp2_6740UKB7rtkWrOr96NMmOEGCx6
 vKNdBoDatGo3WBhyGPRC3ibDzwnKyUNZ3Sb8ucF86Q75T3oh7Gf6aqHt4OPg
 9sCGDo1evYERwKX1oWSJbiQ3Jvlw4NV5GA5gEDaUaRX_7fIlfGQcTfvvwPLI
 rkszQV8IIstYegC7i.Zbmk_9i7OhlijLFmq9HyFWpuIsPFHP.XEo8iHe2eNi
 oaP0zBCrywT_WJPDBZp2QfpCwWuwR1vow6GkS5fEYv_qwqaqxs3tXMbjisWq
 yEJp.fhe91pRpoWUEyb1snxSIQQCzFh_4JkMFCJ4_jBlZiMsHcJ0zQ6nDkjG
 dhUxK0fkWqF3smCiW081Q.Q5nukNPjOWba2aLkKOe2.a6LbA5TV_INnX1BhG
 VyuhRvyl3.nPqYfeZY3Bc7D0Y6ZOthoXFB.a3rde_2y2gM5CsScg0Pvb31cb
 21ZQuucwRv7U8sxxiR7_l4txAM2zLu.5VhJRdrDU9kqpWtbkxNlIDeXIXbtS
 AvkjICR0R.FMQPW16eqYu6lD3ATNCZdMIL5b7sj4S5.FQ2kcmQt4WNukRPBK
 CHBN3LUdHX2cMGjUNXtcXc80Iz8z._ptcbRJVJD1uXPSk4RCtE53UcMitkmG
 VLovt26bRdji4g_jXoIEucVD7YWjEzMIVDnWfCarGqWg.ujjV_rj88p5Ues0
 iphIDPDL47gGBajbUx6thdMr0SRkfbQgvn_0_Bqrr6mDZs9hr1ho8K9HRl3D
 awQcG0uZUjkoqwGTINzl_UzyCUc8ACbIyRSR2wQOeU3rZPMTG8fcrqLND63h
 ZssV9rk2ClVhpc4kYBTGpGuu7G3hk4f4eeXRl6AOmci1.2Yo6kQIGkeuEF4z
 KO6SpTAyk7KYjYHBwgQGFej3s_VeVW9KBy2eHY1TAl12ubT67EyQsvcHjhc1
 9SzBFCsTpjhtPiTe4XddHazlII3205i550kvrH4RUENRkajT3mMQtyXFcJoN
 UALAqV49_Gn359dJbTzIhYLJIuV5NxTJX.wHqmGeObTOt.lxRRMt16DfHMvQ
 PdMtTwZZ88vFp0KqmoQjT.c1lxmaeQnlF6PKHM_H.ZmFCcbCi.gjfc9Uj6zc
 5tvXKBFhmhkXEsQ--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Thu, 16 Sep 2010 06:52:58 -0700 (PDT)
From: K Gutseri <michaelvonbehren@sbcglobal.net>
Reply-To: ksenia.gutseri@w.cn
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am Mrs. Ksenia Gutseriyev, the wife of Russian multi billionaire Mr. Mikhail Gutseriyev's, the former owner of Russneft Oil Company in Russia, i have a proposal for you, if intrested contact me for more info ok.
