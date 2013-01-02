Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3ABLxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 06:53:04 -0500
Received: from nm12-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.246]:46849
	"EHLO nm12-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab3ABLxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 06:53:00 -0500
X-Yahoo-Newman-Id: 949035.20536.bm@smtp129.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Pn1aPvEVM1kcBb7r3_rG6vRf7_SmsrVkyHiVjHBFZ6cFdlR
 8Zt_ALww5AJIRSohI2toBkNVL9667J889X.g0P8p3wfOPnosPa.rNCtjrgWV
 DysG_j1JwPbbZiuk2NjELTbvwD0JWWbz0c3ElXMhWraDKvqk539hrXo8.fQb
 ChnrDc6kvujwVUIqF22YUayscAC4nc.okrsfw3wVBmv9iC2l4Xt7WC2N8lQ4
 Cv2Mq15pjVEDkB1EewuhB3QVGCoyklOKqD0l6cgti6QVt6jd06DAU3NAsXWB
 MAtvDz8JcrheeytmU7Gygp9kzm4URI_6CM9yABYcp.ftcT6MJxYAUasyrkCF
 23dxPkgywp2o6PR27cULs.EtMA1eelnQPFgkabob8PWxSjHHJFVx9r0.gcNj
 JxNhgUCUOD0vgrRt0_m2eR67UZQTKO2O8u6ZeMavcvFGkwR03og--
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH 20/29] batman-adv: rename random32() to prandom_u32()
Date: Wed, 2 Jan 2013 19:52:49 +0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Antonio Quartulli <ordex@autistici.org>,
        Akinobu Mita <akinobu.mita@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, akpm@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com> <1356315256-6572-21-git-send-email-akinobu.mita@gmail.com> <20121225113036.GD2604@ritirata.org>
In-Reply-To: <20121225113036.GD2604@ritirata.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301021952.49979.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 25, 2012 19:30:36 Antonio Quartulli wrote:
> On Mon, Dec 24, 2012 at 11:14:07AM +0900, Akinobu Mita wrote:
> > Use more preferable function name which implies using a pseudo-random
> > number generator.
> > 
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > Cc: Marek Lindner <lindner_marek@yahoo.de>
> > Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> > Cc: Antonio Quartulli <ordex@autistici.org>
> > Cc: b.a.t.m.a.n@lists.open-mesh.org
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: netdev@vger.kernel.org
> 
> Acked-by: Antonio Quartulli <ordex@autistici.org>

Applied in revision 02c5591.

Thanks,
Marek
