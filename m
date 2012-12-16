Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2LPL6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:58:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60610 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2LPL6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:58:13 -0500
Date: Sun, 16 Dec 2012 11:57:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and
	clk_disable_unprepare()
Message-ID: <20121216115756.GO14363@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com> <1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com> <CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 05:10:36PM +0530, Viresh Kumar wrote:
> On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > We'll need to invoke clk_disable_unprepare() via a pointer in our devm_*
> > conversion so let's uninline the pair.
> >
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Mike, are you taking these patches?

And what about my comments, some of which you've failed to reply to?
