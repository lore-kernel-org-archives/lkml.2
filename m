Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab1KFOXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 09:23:17 -0500
Received: from nm22-vm5.bullet.mail.ukl.yahoo.com ([217.12.10.251]:25359 "HELO
	nm22-vm5.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752566Ab1KFOXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 09:23:13 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Nov 2011 09:23:12 EST
X-Yahoo-Newman-Id: 96067.42401.bm@smtp139.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: apyP.lQVM1mSVLqGKY8DubZTMEeS2SMjoiYYQsThHRhpijk
 fF3pc.W3OeLAuhk5pgR_BP6OoBrg6cUJTpc229rjoBJuQ0Wql2v5ohgODxcy
 TalHx.08fM0nhJ2XJ1muFCo48bwTRspU1GbVQofBB4e4sC473AlfuLtdF1fZ
 J9rgvfki5R2W56rXZMIEgG19NG4BlEYfoFRSbmCV3PfmcswFhUy8tyHJq0ks
 .51sizRp9PC_oyKpiB9yDJtMdDgmYuIdEjiEedCJsULgbT40.20agKbKT6Kx
 wLA7oyHwWW_kb5G4U6NINFRHv_nui6jyJHL435nzm1IHuYj8U_dKNLgEYCEV
 kWbZ5Zc1lah4A4dR6zFYtSCY02akX6Tdbl_0z70Kfu1xJjw--
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH 1/5] net/batman-adv: use kstrtoul, etc
Date: Sun, 6 Nov 2011 22:16:46 +0800
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Julia Lawall <julia@diku.dk>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        "David S. Miller" <davem@davemloft.net>
References: <1320586010-21931-1-git-send-email-julia@diku.dk> <1320586010-21931-2-git-send-email-julia@diku.dk>
In-Reply-To: <1320586010-21931-2-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111062216.46584.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 06, 2011 21:26:46 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use kstrtoul, etc instead of the now deprecated strict_strtoul, etc.

Thanks for the patch but we already have a patch lined up to address the 
issue. It will be submitted to net-next in the next week or so.

Regards,
Marek
