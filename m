Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0JUJ1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:27:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51890 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab0JUJ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:27:09 -0400
Date: Thu, 21 Oct 2010 11:27:06 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] Removal of dead code from arch/arm/*
Message-ID: <20101021092706.GI19834@pengutronix.de>
References: <AANLkTim+vj_OAd22TdThuC-HSqUiDjguOHQWjyqFaq6N@mail.gmail.com> <AANLkTi=Cpq2_vV2RGcoQhrqk8xpL59AvLFPzfvTBk5Xa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Cpq2_vV2RGcoQhrqk8xpL59AvLFPzfvTBk5Xa@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 08:32:06AM +0800, Eric Miao wrote:
> On Thu, Oct 21, 2010 at 8:23 AM, Zimny Lech
> <napohybelskurwysynom2010@gmail.com> wrote:
> > Hi,
> >
> > I will begin testing this, I would like to know your opinion about this patches
> > git pull git://github.com/napohybelskurwysynom2010/Linux-2.6-nps.git rodc1
> 
> Would be great if you can post the patches instead of letting people
> figuring out
> how to peek into your changes? (although a combination of "git remote add" +
> "git fetch" + "git log <your remote branch>" can do the trick, not that straight
> forward)
<gitlesson>

Actually the easiest and AFAICT most unintrusive way to get this branch
is:

	~/linux-2.6$ git fetch git://github.com/napohybelskurwysynom2010/Linux-2.6-nps.git rodc1
	....

	~/linux-2.6$ gitk origin/master..FETCH_HEAD

This doesn't even create a branch and the objects are subject to garbage
collection after the next fetch (i.e. when they aren't referenced by
FETCH_HEAD anymore).

And (as a small side note) you can combine git remote add + git fetch by
passing -f to git remote add.

</gitlesson>

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
