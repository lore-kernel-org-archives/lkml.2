Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2FKDGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:06:32 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:19896 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2FKDGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:06:31 -0400
Message-ID: <1339383989.3025.2.camel@lorien2>
Subject: Re: [PATCH v2] leds: fix led_brightness_set when soft-blinking
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Bryan Wu <bryan.wu@canonical.com>
Cc: shuahkhan@gmail.com, Fabio Baltieri <fabio.baltieri@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Date: Sun, 10 Jun 2012 21:06:29 -0600
In-Reply-To: <CAK5ve-L7UWAMErdVBLXGtJr7esQJ=0TCQfD+pyDbA+qdBVNuqQ@mail.gmail.com>
References: <20120606070008.GA1494@gmail.com>
	 <1338967142-6249-1-git-send-email-fabio.baltieri@gmail.com>
	 <CAK5ve-+gv=83MLAttiq8NYK0d_242UWRjJZftyKHONqMkxWTxQ@mail.gmail.com>
	 <20120606111007.GA1311@gmail.com>
	 <CAK5ve-LrnZQqAi2tamFfdN1_upjGQ=TYgpU-xLXnL+8xRv=+Xw@mail.gmail.com>
	 <20120606191149.GA1376@gmail.com> <1339014612.2763.98.camel@lorien2>
	 <CAK5ve-L7UWAMErdVBLXGtJr7esQJ=0TCQfD+pyDbA+qdBVNuqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 20:58 +0800, Bryan Wu wrote:

> 
> Hi Fabio, thanks for updating this. I've added use the v3 replace the
> old one in my for-next and devel branches
> 
> Shuah, Thanks for reviewing, if you wanna try this, just grab patches
> from devel branch.
> 

Bryan,

Did some testing on your devel branch. Did back to back timer and
oneshot trigger activations and didn't see any problems. Looks good to
me.

-- Shuah

