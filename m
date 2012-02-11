Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2BKLS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 06:18:56 -0500
Received: from nm15-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.252]:44925
	"HELO nm15-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754344Ab2BKLSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 06:18:55 -0500
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Feb 2012 06:18:54 EST
X-Yahoo-Newman-Id: 975661.11833.bm@smtp139.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6ALRAvYVM1knuX8tnDOYCgspoUX.Ne0EknfIZH40ch6Ql.j
 eGEX70unBI0PvE29ZaF5q.TTbrIVn6sAMXFB5b2prHRrMhgGGb5LSRX.pBp1
 wvyt_moSrcqndFP31zZ0Yx3DXx8MVauJPpdmj8gxfCPNuiBpCI5YF3jccTW5
 JyZHQP5GM3OqVEzKdEKp8mny59sEpi39fjMbaagLeflzitmYqZWdefL4D4Ed
 spBAARpzcQZBGdGL4UYPiCmADfetxZIaPXzE0zoRsJGnwGdguXoKiIaMXf2j
 y.1TUrLB36vx2rHppklBivvrF4B6b0H9EDEdfgP_2sX.1ZEsHv0Mvws5DJxg
 MuhtxPaFvwnX2hkO39Rj3ak2vcs5topM.i5bct5Td2yyo8Ap8Jc_MlACW51J
 8Zw--
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH 40/50] batman-adv: use dev_hw_addr_random() instead of random_ether_addr()
Date: Sat, 11 Feb 2012 19:12:11 +0800
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Danny Kukawka <danny.kukawka@bisect.de>, netdev@vger.kernel.org,
        Danny Kukawka <dkukawka@suse.de>, linux-kernel@vger.kernel.org,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        "David S. Miller" <davem@davemloft.net>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <1328735457-29986-41-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1328735457-29986-41-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202111912.12522.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 09, 2012 05:10:47 Danny Kukawka wrote:
> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.

Applied (with minor modification) in revision 910ccac.

Thanks,
Marek
