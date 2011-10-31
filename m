Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab1JaJkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:40:05 -0400
Received: from smtprelay0212.b.hostedemail.com ([64.98.42.212]:60160 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932359Ab1JaJkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:40:03 -0400
X-Panda: scanned!
X-Spam-Summary: 2,-1.05263,0,7c8438a5d6fc5942,d41d8cd98f00b204,t.artem@lycos.com,hmh@hmh.eng.br:linux-kernel@vger.kernel.org,RULES_HIT:152:355:379:541:582:599:601:945:973:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1540:1593:1594:1676:1711:1730:1747:1766:1792:2393:2553:2559:2562:2691:2692:3027:3138:3352:3865:3867:3868:3869:3870:3871:3873:3874:4250:5007:6261:7688:7901:7903:10004:10016:10400:11658:11914,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:none,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1843
Date: Mon, 31 Oct 2011 09:40:01 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: hmh@hmh.eng.br
Cc: linux-kernel@vger.kernel.org
Message-ID: <574299906.69412.1320054001912.JavaMail.mail@webmail05>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111030212644.GA7106@khazad-dum.debian.net>
 <815860869.50724.1320011477430.JavaMail.mail@webmail17>
 <20111031091607.GB7106@khazad-dum.debian.net>
Subject: Re: Re: HT (Hyper Threading) aware process scheduling doesn't work
 as it should
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.125.4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Oct 31, 2011, Henrique de Moraes Holschuh  wrote: 
> 
> On Sun, 30 Oct 2011, Artem S. Tashkinov wrote:
> > > Please make sure both are set to 0.  If they were not 0 at the time you
> > > ran your tests, please retest and report back.
> > 
> > That's 0 & 0 for me.
> 
> How idle is your system during the test?

load average: 0.00, 0.00, 0.00

As I've mentioned great many times I run this test on a completely idle system
(i.e. I even `init 3` in advance to avoid any unexpected CPU usage spikes
caused by unrelated processed).

I have to insist that people conduct this test on their own without trusting my
words. Probably there's something I overlook or don't fully understand but from
what I see, there's a serious issue here (at least Microsoft XP and 7 work exactly
the way I believe an OS should handle such a load).

Artem
