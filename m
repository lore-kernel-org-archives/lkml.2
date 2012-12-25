Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2LYIhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 03:37:08 -0500
Received: from nm25-vm4.bullet.mail.ukl.yahoo.com ([217.146.177.124]:47448
	"EHLO nm25-vm4.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab2LYIhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 03:37:06 -0500
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2012 03:37:05 EST
X-Yahoo-Newman-Id: 767927.61421.bm@smtp118.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WhvlSz0VM1l3V_kS_XnR_qNxfCfXG3PPiy24AgfJKhQvpLe
 VyNBjKQWPtvxc82A.plcGvJQUWAPNdSav1s9GLFC6jrFls9165fAXhsBwQeR
 Iu..TXuPvtX3uxksqtqypRE78talYEUTqAP8SesnNlVv7q_pB6ywndntFBQL
 mZEe2aZXwVgHCbDSnzJrksv2LVa2jp7TihCuBViI.MZgew1kCStVb23Q08SC
 vOr96_0SWevrC0x9qZhYlTiUWNzWsEpysKlzAZBE9h2oO_.xa.veHD7ybf9z
 3NbLhfYeAm0nUxERxo2wuBFPXDFqE__ewHl1DhkcHGOKMG3MfcC9RSCgYIpj
 26p4M3R1x1VvHWkAHlzTEcGGamUv7tDStmMStZeGlakbXDPhf8ZCM6O3O3rM
 sg9NZwSIds0iKGtCYGvPmESJWFkEvUyWrNG5v4lcK7W4Z3xIuiGAN7HvYmS1
 X41wnJvo9fUtr.tre5mpX
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH] net, batman: don't crash on zero length strings in routing_algo
Date: Tue, 25 Dec 2012 16:30:42 +0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Pau Koning <paukoning@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, siwu@hrz.tu-chemnitz.de,
        Sasha Levin <sasha.levin@oracle.com>, davem@davemloft.net
References: <1353355695-23252-1-git-send-email-sasha.levin@oracle.com> <CANiGF9_engsHHNUDnJi6+iczCdu7sBV+UuJ+Xv33pGuJxPeuAg@mail.gmail.com> <201212250336.36874.lindner_marek@yahoo.de>
In-Reply-To: <201212250336.36874.lindner_marek@yahoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212251630.42980.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 25, 2012 03:36:36 Marek Lindner wrote:
> > >> > empty, this assumption is wrong:
> > >> Why isn't this patch part of Linux 3.7? It seems to be a bugfix and it
> > >> was sent early enough?
> > > 
> > > The patch received a reply mere 2 hours after it was sent. Again,
> > > please read all mails before making noise.
> > 
> > Ok, leaving this problem unsolved is the correct way to handle it?
> > Nobody is allowed to say anything?
> 
> No, of course you are allowed "to say" something. I was simply pointing you
> to the explanation why the patch wasn't merged yet.

Let me add here: Feel free to do the required cleanup work and re-submit the 
patch. Nobody stops you from doing that as well.  :-)

Cheers,
Marek
