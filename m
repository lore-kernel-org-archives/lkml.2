Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1GKCuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 22:50:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52919 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab1GKCt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 22:49:58 -0400
Subject: Re: [PATCH 0/4] Add a generic struct clk
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110710090927.GA23445@opensource.wolfsonmicro.com>
References: <1305876469.325655.313573683829.0.gpush@pororo>
	 <1305876469.325655.313573683829.0.gpush@pororo>
	 <20110710090927.GA23445@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 10:49:48 +0800
Message-ID: <1310352588.3591.197.camel@pororo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> Is there a git tree with the current state of this code in it somewhere?
> It's not mentioned here and my google skills are failing me.

No, these are just RFC patches at the moment, so I'm reluctant to
encourage anyone basing other work on them for now. Regardless, they're
the most recent versions, so would be the most suitable place to start
hacking if you're interested.

On a related note, I've not had sufficient time to dedicate to the clk
work recently, so Linus Walleij will be taking over the clk patches, and
he'll be able to spend the necessary time to get things into shape :)

He's on vacation at the moment, but will start at the upcoming Linaro
event in Cambridge, I believe.

Cheers,


Jeremy


