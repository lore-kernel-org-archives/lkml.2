Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2LXToH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 14:44:07 -0500
Received: from nm22-vm6.bullet.mail.ukl.yahoo.com ([217.12.10.37]:21241 "EHLO
	nm22-vm6.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326Ab2LXToF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 14:44:05 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2012 14:44:04 EST
X-Yahoo-Newman-Id: 694383.1528.bm@smtp108.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZLgp6CcVM1mc4.bWvNjlCytkVXPUGUGMH69Zq74nRGYqR9W
 KJojUMXXZOaJxLX0vd0c2Ae91QkFrKTfJag8_P9L4iToxM7.ATdpttEBIgko
 y8K29Ojz842.3kUNPZcrmH8q526K21k5JBi4WWSNBZ6rBnvCiPdfCPB8rrDh
 aIvbLfrFmpqxG3o9NJ.blTqnzgDYvvyADKWwe4tBOvKJssZr6uSJ_UMrSdkS
 EgoGufB7hiFYdXmSYNXmh7.pvUxJetJD0LfSfYL_FX.SEcWpqdU_4w0iB9F_
 RDpIAW.GIR0UhMzDbtC5FxGNNOXclPG1LFfa.2D0BHpC6IJDN.Kg5j2cmhBk
 uKNdafZcRmapdhNlqN0s7d47ZEDs8S8KfByZVZD51YX7Xk9v0cNiiwOL5xUt
 vhpmymmfSajurNsUBGLQvB6TvV5UxjnvFHr.J_3d7xc993QG0
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH] net, batman: don't crash on zero length strings in routing_algo
Date: Tue, 25 Dec 2012 03:36:36 +0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Pau Koning <paukoning@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, siwu@hrz.tu-chemnitz.de,
        Sasha Levin <sasha.levin@oracle.com>, davem@davemloft.net
References: <1353355695-23252-1-git-send-email-sasha.levin@oracle.com> <201212242238.23255.lindner_marek@yahoo.de> <CANiGF9_engsHHNUDnJi6+iczCdu7sBV+UuJ+Xv33pGuJxPeuAg@mail.gmail.com>
In-Reply-To: <CANiGF9_engsHHNUDnJi6+iczCdu7sBV+UuJ+Xv33pGuJxPeuAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212250336.36874.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 24, 2012 23:42:15 Pau Koning wrote:
> On Mon, Dec 24, 2012 at 3:38 PM, Marek Lindner <lindner_marek@yahoo.de> 
wrote:
> > On Monday, December 24, 2012 22:18:52 Pau Koning wrote:
> >> On Mon, Nov 19, 2012 at 9:08 PM, Sasha Levin <sasha.levin@oracle.com> 
wrote:
> >> > The code that works with routing_algo assumes that the string passed
> >> > is non
> >> 
> >> > empty, this assumption is wrong:
> >> Why isn't this patch part of Linux 3.7? It seems to be a bugfix and it
> >> was sent early enough?
> > 
> > The patch received a reply mere 2 hours after it was sent. Again, please
> > read all mails before making noise.
> 
> Ok, leaving this problem unsolved is the correct way to handle it?
> Nobody is allowed to say anything?

No, of course you are allowed "to say" something. I was simply pointing you to 
the explanation why the patch wasn't merged yet.

Cheers,
Marek
