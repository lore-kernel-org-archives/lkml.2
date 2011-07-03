Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1GCCqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 22:46:42 -0400
Received: from 21.98.mail-out.ovh.net ([178.32.119.154]:48538 "EHLO
	98.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754840Ab1GCCqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 22:46:40 -0400
Date: Sun, 3 Jul 2011 04:31:16 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: AT91: Fix pull requset
Message-ID: <20110703023116.GD28000@game.jcrosoft.org>
References: <20110701065411.GD14408@game.jcrosoft.org>
 <201107011709.40359.arnd@arndb.de>
 <20110701183313.GV11559@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110701183313.GV11559@pengutronix.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 15567536538590882656
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:33 Fri 01 Jul     , Uwe Kleine-König wrote:
> On Fri, Jul 01, 2011 at 05:09:40PM +0200, Arnd Bergmann wrote:
> > On Friday 01 July 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > HI Linus, Russell, Arnd
> > For every bug fix you commit, please check if it applies to older
> > kernels as well, and mark with 'Cc: stable@kernel.org' if so. Do you
> > want to update the changelog and send another pull request?
> Or alternatively (i.e. if you don't want to rewrite your tree) just
> writing to stable@kernel.org and indicating the upstream commit ids is
> usually OK, too.
> The other extreme is to point out the affected versions, e.g. by using 
> 
> 	Cc: stable@kernel.org [2.6.xy+]

I known and will have done if needed but those fixes are for this release only

Best Regards,
J.
