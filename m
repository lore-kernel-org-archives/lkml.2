Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2BMSPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:15:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44414 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab2BMSPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:15:23 -0500
Date: Mon, 13 Feb 2012 18:15:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Rabin Vincent <rabin@rab.in>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
Message-ID: <20120213181501.GD25655@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.02.1202022016480.2759@xanadu.home> <1328234629-32735-1-git-send-email-sboyd@codeaurora.org> <CAH+eYFCKcPzMMp_Ef5iX0Xp=xK8MdvJoUBRgKGT56SVjY5DXoA@mail.gmail.com> <alpine.LFD.2.02.1202131307430.24536@xanadu.home> <4F3952C7.3040502@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3952C7.3040502@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 10:13:27AM -0800, Stephen Boyd wrote:
> Thanks. Russell has already merged the original patch to the fixes
> branch. Hopefully he can fold this one in.

Nope, I've asked Linus to pull it.

So do we conclude that the original patch wasn't properly tested? :P
