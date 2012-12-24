Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2LXOoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 09:44:08 -0500
Received: from nm12-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.246]:29573
	"EHLO nm12-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132Ab2LXOoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 09:44:07 -0500
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2012 09:44:06 EST
X-Yahoo-Newman-Id: 706619.85002.bm@smtp126.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QubHwTYVM1nxDMGL9H8Yt6Y7Rzl4VWvcEjCa.CLQtCS5YGO
 58iZXJQf3g9fX4Jz.D9LJnAERfCI968CAUNkk9z0e75XkUMtrmH7UHYHuwfY
 Rbj9nB3iVPUWen86KNRUpXZjVWmE9M7hOLH3O6tw75tOcfpTpSkhE7G1Os8S
 yfu5UUJK3uJeozCZbRzmOHRKlElncU3DB1HpWB7aufti2sMhVJibGnNgKDAU
 K2Sh597M0Cb..EcUag8X8hy1_hBZQf8zVItmRhRy_JwTuiTRBo91dCcwf9i3
 D0WVGBN29MfEJzrDkLTlrkrzLqthMBYgk2DNWZ0AEUavrC5UlMy.ixgJgY.C
 n3K6jXDqpE03Mh4Io_OPeMtm.TkNIvbujNOP.8HEyZAYDeyWiOzK.rboPEXH
 yCQpmNSPVcnisy6AFPn4C7Y3VoKksuXVD81EWoKQ5seoVQdAT
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH] net, batman: don't crash on zero length strings in routing_algo
Date: Mon, 24 Dec 2012 22:38:22 +0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Pau Koning <paukoning@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, siwu@hrz.tu-chemnitz.de,
        Sasha Levin <sasha.levin@oracle.com>, davem@davemloft.net
References: <1353355695-23252-1-git-send-email-sasha.levin@oracle.com> <CANiGF9-_roU2oD5uTRvjvaS5=bv-VoRBdULZN3PtgFzs5z1=CQ@mail.gmail.com>
In-Reply-To: <CANiGF9-_roU2oD5uTRvjvaS5=bv-VoRBdULZN3PtgFzs5z1=CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212242238.23255.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 24, 2012 22:18:52 Pau Koning wrote:
> On Mon, Nov 19, 2012 at 9:08 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> > The code that works with routing_algo assumes that the string passed is
> > non
> 
> > empty, this assumption is wrong:
> Why isn't this patch part of Linux 3.7? It seems to be a bugfix and it
> was sent early enough?

The patch received a reply mere 2 hours after it was sent. Again, please read 
all mails before making noise.

Thanks,
Marek
