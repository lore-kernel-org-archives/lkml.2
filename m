Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0GRJFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 05:05:09 -0400
Received: from khc.piap.pl ([195.187.100.11]:55119 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab0GRJFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 05:05:06 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Dimitrios Apostolou <jimis@gmx.net>,
        linux-kernel@vger.kernel.org, Dan Nicolaescu <dann@gnu.org>
Subject: Re: emacs and "linux" coding style
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
	<m3tyny31mo.fsf@intrepid.localdomain>
	<20100717065146.732f5449.rdunlap@xenotime.net>
	<20100718071552.GB4684@thunk.org>
Date: Sun, 18 Jul 2010 11:05:02 +0200
In-Reply-To: <20100718071552.GB4684@thunk.org> (Ted Ts'o's message of "Sun, 18
	Jul 2010 03:15:52 -0400")
Message-ID: <m3zkxpf9dt.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o <tytso@mit.edu> writes:

> Actually, what my code use is tabs with a tab stop of 8 followed by
> enough spaces (< 7) to align function parameters and to align
> open/close parenthesis in C expression line wrap.

To be honest, I do precisely the same, though I think it's far from
perfect. It's just emacs which can't do better (or I don't know how to
make it do better).

> The main problem seems to be that Chapter 9 in
> Documentation/CodingStyle is written by someone who feels that since
> vi makes it easy to only align parameters using tabs, that everybody
> should do it the same way as vi.  I'm simply challenging Chapter 9 as
> being canon.  I certainly ignore it, and as a maintainer I tend to
> accept either vi or emacs-style indentations with respect to
> parameters and C expressions.

Fully agreed.
-- 
Krzysztof Halasa
