Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab0EURuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:50:03 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45468 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509Ab0EURt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:49:59 -0400
Message-ID: <4BF6C7B6.2020008@euromail.se>
Date: Fri, 21 May 2010 19:49:42 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Ping Cheng <pinglinux@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se> <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com> <4BF6B673.1080507@euromail.se> <20100521165218.GA26439@core.coreip.homeip.net> <4BF6BB43.2020405@euromail.se> <20100521172222.GB26439@core.coreip.homeip.net> <4BF6C303.7030804@euromail.se> <20100521174140.GA23155@core.coreip.homeip.net>
In-Reply-To: <20100521174140.GA23155@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OFWLz-0005kj-7C.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OFWLz-0005kj-7C 0835095f7ce7480dfa43327b34fbf83e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> 
> I guess this is where our disconnect lies as when I am looking at the
> event names I view all *_MT_* events as related to the multitouch
> protocol handling.
> 

Yes. It is true that slot control is MT related, but I am looking at this from
the perspective of future expansions like KEY_MT,  KEY_REL, and such, finding a
way to signal to user space which events are handled via slots. If we had
ABS_MT_SLOT, we would most likely get applications which store ABS_MT_SLOT as an
attribute of the slot together with ABS_MT_POSITION_X, ABS_MT_TOUCH_MAJOR, etc,
which is just not right. So the proposal is ABS_SLOT. May we have your verdict,
please. :-)

Henrik
