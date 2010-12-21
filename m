Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0LUXvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:51:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38484 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752191Ab0LUXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:51:14 -0500
Date: Tue, 21 Dec 2010 23:51:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rabin Vincent <rabin@rab.in>, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Message-ID: <20101221235127.GC10081@opensource.wolfsonmicro.com>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
 <201012181559.50347.rjw@sisk.pl>
 <20101220150051.GI26706@rakim.wolfsonmicro.main>
 <201012202213.53902.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012202213.53902.rjw@sisk.pl>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 10:13:53PM +0100, Rafael J. Wysocki wrote:

> Well, the _solution_ is to get rid of the legacy stuff from those buses in the
> first place.  Then, they'll just need to use the generic ops without any
> trouble.

> What you're proposing is a workaround that people will use as an excuse for
> not doing the right thing forever.

I hadn't actually realised that there was any urgency about removing the
old APIs - I'd not really seen much work in that direction.  If the
intention is to actively push people over to dev_pm_ops that does make a
bit more sense.
