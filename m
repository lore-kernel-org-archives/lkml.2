Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab2AAKl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 05:41:59 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:47863 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2AAKl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 05:41:57 -0500
Date: Sun, 1 Jan 2012 11:41:52 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 3.2.0-rc5 oops in ext4
Message-ID: <20120101104152.GA14413@uio.no>
References: <20120101024754.GA14376@uio.no>
 <20120101042345.GA22312@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120101042345.GA22312@thunk.org>
X-Operating-System: Linux 3.2.0-rc5 on a x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 31, 2011 at 11:23:45PM -0500, Ted Ts'o wrote:
> This wasn't the whole kernel oops message.  Can you get any lines
> earlier than this?

Sorry, no; that's where the syslog entry starts. I should have captured it
from the SSH session there and then, of course, but I assumes syslogd would
get it all.

In any case, if it's fixed in -rc6, I'll wager another reboot (to -rc7) and
hope the problem is already solved.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
