Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1H3K7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:59:00 -0400
Received: from nm5.bullet.mail.ukl.yahoo.com ([217.146.182.226]:20406 "HELO
	nm5.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753193Ab1H3K66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:58:58 -0400
X-Yahoo-Newman-Id: 646206.57629.bm@omp1013.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=DKIM-Signature:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=hnsIE/MbwX6X+zMHjuizKZB4BnoiZgO1zGkZVBf1Llr8vzLA5jfMZ0uDbu1+izQcojivKyGIXn5Hx7DWzjJt9rJDfNypxvqYMK1v3QyvRK757y7TyymB310FtaUXgjrvVZgq9w1OekhX4WtYOgwO4EVb6TyGBD40r2GvM2L/TUs=  ;
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ORNBAKsVM1mO1tXcisc6YghWPkHHB4MSboXtAkk0vGzbsZt
 VMkO7J1DLRRXUyMYVIz7p72g4zcGKbU31sCyzwSlJIe2wwOvCFFUOd6W1x6_
 .ajXu057QIqEGtUqCwp9f4Qn7ZK7aVZdZbJ_J6Goyyo8BStlOEZ.Wnfhrpi2
 GTEAfVioWKyuy_VGKzUyohXgeXUl7WO2pvfQ6n.6YPQzauOqgatgSwnILpkS
 8zPlq2UFThQjLnhgIQRhipwT.PShibRrddGfEwTmOjVdCAy.lIMj._gB0Ohg
 AmmwTVXRFluDMEFEmI5IFP9iLJU1tZaNZmxzAGMx.w_293dgLre3ahm7woEx
 myhoiMMpT.NM1jaqlLeazPll.Mr71xFR2SVGREKg5yKNPibJd
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH 05/24] batman-adv: Remove unnecessary OOM logging messages
Date: Tue, 30 Aug 2011 12:58:41 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-1-amd64; KDE/4.6.3; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <cover.1314650069.git.joe@perches.com> <c469b9fb57fb75547e3e9092ebfdb3a79480b28f.1314650069.git.joe@perches.com>
In-Reply-To: <c469b9fb57fb75547e3e9092ebfdb3a79480b28f.1314650069.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301258.41945.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 29, 2011 23:17:24 Joe Perches wrote:
> Removing unnecessary messages saves code and text.
> 
> Site specific OOM messages are duplications of a generic MM
> out of memory message and aren't really useful, so just
> delete them.

Applied in our tree.

Thanks,
Marek
