Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1IIGlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:41:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60008 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1IIGlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:41:02 -0400
Date: Fri, 9 Sep 2011 08:40:58 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>
Subject: Re: linux-next: manual merge of the i.MX tree with the arm-soc tree
Message-ID: <20110909064058.GF28816@pengutronix.de>
References: <20110909114436.5afc4ef772143d90ce75c7c5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110909114436.5afc4ef772143d90ce75c7c5@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

(I'm responsible for this, as Sascha is on vacation.)

On Fri, Sep 09, 2011 at 11:44:36AM +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the i.MX tree got a conflict in
> arch/arm/plat-mxc/devices/platform-pata_imx.c between commit 236c4e8be436
> ("ARM: imx: Add PATA resources for other i.MX processors") from the
> arm-soc tree and commit 8354b5d2a1c5 ("ARM: imx: Add PATA resources for
> other i.MX processors") from the i.MX tree.
> 
> The latter appears to be a corrected version of the former (despite
> having the same Author date ...) so I used that.
Yeah, if you look at the commit logs you will notice that the better
commit has an additional comment:

    [ukleinek: squashed in a fix by Arnaud Patard (Rtp) <arnaud.patard@rtp-net.o
    fixing the resource size calculation]

Arnd already promised me to replace the older version of the imx tree in
arm-soc with the current one. The problem is just that kernel.org is
down ...

Do you prefer that conflicts like these are resolved before you get
them?
(I.e. I could have done

	git merge -s ours $somecommitfromthearmsoctree

but I wasn't sure that this is a good idea and so decided to wait until
you write a mail about the conflict.)

Best regards
Uwe


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
