Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab1BGMtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:49:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54067 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab1BGMto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:49:44 -0500
Date: Mon, 7 Feb 2011 13:48:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110207124846.GA10442@elte.hu>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> It is very rare to find a current system which is both sufficiently
> resource constrained to want to compile out power management support
> and sufficiently power insensitive to be able to tolerate doing so.
> Since having the configuration option requires non-zero effort to
> maintain, with ifdefery in most drivers, but it is used with vanishing
> rarity it is simpler to just remove the option.

Well, either make it dependent on CONFIG_EXPERT or remove the option altogether.

Thanks,

	Ingo
