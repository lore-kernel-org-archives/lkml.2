Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab2KVWbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:31:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49161 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab2KVWbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:31:48 -0500
Date: Thu, 22 Nov 2012 09:31:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Turquette <mturquette@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121122093101.GB5764@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com> <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com> <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com> <20121121204324.21126.99677@nucleus> <20121121205424.GA25470@core.coreip.homeip.net> <20121121223859.GQ3290@n2100.arm.linux.org.uk> <20121122021750.GD25470@core.coreip.homeip.net> <20121122031117.GE25470@core.coreip.homeip.net> <20121122032407.21126.49680@nucleus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122032407.21126.49680@nucleus>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 07:24:07PM -0800, Mike Turquette wrote:
> Looks right to me.  Just need to remove the select from IMX as well.

Then you don't understand HAVE_CLK_PREPARE.
