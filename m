Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2G3I24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:28:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47471 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2G3I2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:28:54 -0400
Date: Mon, 30 Jul 2012 01:28:49 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Bret Towe <magnade@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: crash in ocfs2_fast_symlink_readpage in kernel 3.5.0
Message-ID: <20120730082849.GF4025@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: Bret Towe <magnade@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CALjC5hYxtPymauFddf4Qci3S-KsZHHck0LKQPZY5ocHcLw-XrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjC5hYxtPymauFddf4Qci3S-KsZHHck0LKQPZY5ocHcLw-XrQ@mail.gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 01:16:21PM -0700, Bret Towe wrote:
> just booted a fresh 3.5 kernel and got the following on login via gdm
> on the client computer
> didn't see any crashes yet on any other computer but didn't give it
> long to try after seeing this
> let me know if you need more info
> this client is running debian wheezy 64bit

This is a different stack trace than another recent report.  Quick
question: have you run 3.4 on this system?

Joel

-- 

"There is no more evil thing on earth than race prejudice, none at 
 all.  I write deliberately -- it is the worst single thing in life 
 now.  It justifies and holds together more baseness, cruelty and
 abomination than any other sort of error in the world." 
        - H. G. Wells

			http://www.jlbec.org/
			jlbec@evilplan.org
