Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3AHJ1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:27:00 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:54079 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3AHJ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:26:57 -0500
Date: Tue, 8 Jan 2013 01:26:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linus.walleij@linaro.org, arnd@arndb.de
Subject: Re: [PATCH 4/5] Input: Enable STMPE keypad driver for Device Tree
Message-ID: <20130108092653.GA29695@core.coreip.homeip.net>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-5-git-send-email-lee.jones@linaro.org>
 <20130108083803.GY21994@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108083803.GY21994@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jan 08, 2013 at 08:38:03AM +0000, Lee Jones wrote:
> 
> I'm less than pleased that you _stole_ authorship of this patch!
> 
> Especially, as I've been asking you to review it for some time.

My sincere apologies, it was never my intention to claim anyones work as
my own.

It appears that "stg squash" command (I use stacked git to manage my WIP
queue) produces result with authorship changed to the committer and if
you check the thread you will see that I explicitly mentioned that I
folded the device tree binding documentation (that was also authored by
you) into this patch.

Now that I am looking it appears that sysrq keyreset patch by Mathieu
Poirier was also committed as authored by me, and on that patch I aslo
used "stg squash".

OK, I'll now be aware of this behavior and I will rewind my 'next'
branch and correct the authorship on the commits.

Again, I apologize.

-- 
Dmitry
