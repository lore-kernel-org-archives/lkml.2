Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab0FDOPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:15:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43312 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab0FDOPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:15:19 -0400
Date: Fri, 4 Jun 2010 10:09:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>,
       GeunSik Lim <geunsik.lim@samsung.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Lukas Turek <8an@praha12.net>,
       Mark Hindley <mark@hindley.org.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>, Kalle Valo <kalle.valo@iki.fi>,
       Keng-Yu Lin <keng-yu.lin@canonical.com>,
       Luca Verdesca <magooz@salug.it>, Shahar Or <shahar@shahar-or.co.il>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ath5k][leds] Ability to disable leds support. If leds
 support enabled do not force mac802.11 leds layer selection.
Message-ID: <20100604140919.GA2492@tuxdriver.com>
References: <4c0804e2.0c3ddf0a.2771.10f7@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c0804e2.0c3ddf0a.2771.10f7@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:39:30PM +0300, Dmytro Milinevskyy wrote:
> Hi!
> 
> Here is the patch to disable ath5k leds support on build stage.
> However if the leds support was enabled do not force selection of 802.11 leds layer.
> Depency on LEDS_CLASS is kept.
> 
> Suggestion given by Pavel Roskin and Bob Copeland applied.
> 
> Regards,
> 
> --Dima

Needs at least a Signed-off-by line, and preferrably a changelog that
explains what the patch is doing and (especially) why it is necessary.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
