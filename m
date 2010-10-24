Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0JXOwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 10:52:25 -0400
Received: from solo.fdn.fr ([80.67.169.19]:53931 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab0JXOwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 10:52:24 -0400
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Oct 2010 10:52:24 EDT
Date: Sun, 24 Oct 2010 16:41:51 +0200
From: Samuel Thibault <sthibault@debian.org>
To: Tom Vier <tom@triadsys.com>
Cc: 594089@bugs.debian.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dtor@mail.ru
Subject: Re: Bug#594089: keyboard-configuration: caps lock keycode problem
Message-ID: <20101024144150.GV24091@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <sthibault@debian.org>,
	Tom Vier <tom@triadsys.com>, 594089@bugs.debian.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	dtor@mail.ru
References: <20100823154353.2805.13525.reportbug@tom.tse> <20100903235540.GA9149@const> <4C866913.3030201@triadsys.com> <4C8E6861.1070502@triadsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C8E6861.1070502@triadsys.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The short story is: Tom's keyboard sends all that when he presses caps
lock:

press: 0x3a 0xe0 0x66
repeat: 0x3a
release: 0xba 0xe0 0xe6

0xe0 0x66 happens to be the "favorites" key on his keyboard with
internet navigation keys.  I thus believe there's a bug in his keyboard
that needs to be filtered at the kernel level.

The long story can be read on http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594089

Tom Vier, le Mon 13 Sep 2010 14:07:29 -0400, a écrit :
> Here's xev from Stable. It looks like in Testing that some of the extra 
> key codes that show up in showkey are getting interpreted as additional 
> key presses in Testing's xorg but not Stable's.

Yes, as I said in a previous mail, squeeze Xorg now interprets the
internet scancodes by default, while it wouldn't in lenny and previous,
thus not showing the bug.

Samuel
