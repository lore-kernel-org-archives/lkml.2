Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1KGMEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:04:49 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:21062 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1KGMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:04:48 -0500
Date: Mon, 7 Nov 2011 13:04:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: balbi@ti.com, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
Message-ID: <20111107130432.3309ffd6@endymion.delvare>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B38B2AB@wm021.weinmann.com>
References: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
	<20111107094701.GF4265@legolas.emea.dhcp.ti.com>
	<EF2E73589CA71846A15D0B2CDF79505D087B38B21C@wm021.weinmann.com>
	<20111107100446.GG4265@legolas.emea.dhcp.ti.com>
	<EF2E73589CA71846A15D0B2CDF79505D087B38B2AB@wm021.weinmann.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011 12:06:52 +0100, Voss, Nikolaus wrote:
> > > > IMHO, you should split this patch into three or more smaller patches.
> > > > You're doing lots of different things in one commit and it'll be a
> > > > pain to bisect should this cause any issues to anyone.
> > >
> > > I didn't split the patch because it is virtually a complete rewrite.
> > > Due to the severe limitations of the old driver, I think it should
> > > replace the old driver.
> > 
> > The final decision is up to Ben and/or Jean but I think we should always have
> > incremental patches, not sure if we should allow big patches for the reasons
> > above.

The final call is obviously to Ben, not me, as this driver falls under
his jurisdiction. But for what it's worth, I consider the small-steps
rule void when it comes to fixing a plain broken driver by almost fully
rewriting it. The reviewer should really review the resulting code
rather than the patch. If it makes everybody happier, then killing the
old code completely first is certainly an option.

-- 
Jean Delvare
