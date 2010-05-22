Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0EVOqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 10:46:46 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55505 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0EVOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 10:46:43 -0400
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol
 (rev3)
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Rafi Rubin <rafi@seas.upenn.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Ping Cheng <pinglinux@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
In-Reply-To: <4BF7B438.8000001@euromail.se>
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se>
	 <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com>
	 <4BF6B673.1080507@euromail.se>
	 <20100521165218.GA26439@core.coreip.homeip.net>
	 <4BF6BB43.2020405@euromail.se>
	 <20100521172222.GB26439@core.coreip.homeip.net>
	 <4BF6C303.7030804@euromail.se>
	 <20100521174140.GA23155@core.coreip.homeip.net>
	 <4BF6C7B6.2020008@euromail.se> <4BF7A4E8.3050806@seas.upenn.edu>
	 <4BF7B438.8000001@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 May 2010 10:46:22 -0400
Message-ID: <1274539582.13705.132.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-22 at 12:38 +0200, Henrik Rydberg wrote:
> Getting serious, it is anyone's guess what will happen next, but I was picturing
> a table, with a large multitouch screen and buttons along the side of the table.
> Sure, we can do "ABS_BTN_0", "ABS_BTN_1", etc, but with slots in place, it seems
> more natural to use something like "ABS_MT_BTN_X". While at it, REL_MT event
> makes sense for those touchscreen techniques which register changes, like
> acoustic pulse recognition.

Shouldn't this be handled in userspace? I don't think we want to be
quirking drivers for instances where the same touchscreen is overlaid on
buttons in some cases, but not in others. If we don't quirk, we'd need
some mechanism to tell the driver about such buttons.

-- Chase

