Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1F3TpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:45:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34545 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1F3TpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:45:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110630170229.GP6069@pengutronix.de>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de>
	<1309430517-23821-2-git-send-email-s.hauer@pengutronix.de>
	<BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com>
	<201106301441.24493.arnd@arndb.de>
	<BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com>
	<20110630170229.GP6069@pengutronix.de>
Date: Thu, 30 Jun 2011 14:45:11 -0500
Message-ID: <BANLkTikEigJk0nzyhXsWKWGSJQBbTVSerg@mail.gmail.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
From: Bill Gatliff <bgat@billgatliff.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha:

On Thu, Jun 30, 2011 at 12:02 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> So please don't complain too much: We are currently only doing the work
> you didn't want to do.

Per request of some the early reviewers, my plan was to migrate
existing users over to the new API after the API itself was committed
to mainstream.

At any rate, this isn't a question of work I didn't "want" to do.  On
the one hand, I was simply doing what was asked of me.  On the other
hand, I was trying to make progress while simultaneously dealing with
serious family matters that are still unresolved.

At any rate, it's clear that your patches are going in, and mine
aren't--- I have no choice but to accept that.  I'm just frustrated by
the duplication of effort.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
