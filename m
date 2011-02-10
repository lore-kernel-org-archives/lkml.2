Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1BJSRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:17:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1BJSRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:17:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andries Brouwer <aebr@win.tue.nl>
X-Fcc: ~/Mail/linus
Cc: Arnd Bergmann <arnd@arndb.de>, linasvepstas@gmail.com,
        Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
In-Reply-To: Andries Brouwer's message of  Thursday, 10 February 2011 19:12:21 +0100 <20110210181221.GA19413@win.tue.nl>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
	<201101251529.24779.arnd@arndb.de>
	<20110125174515.C1DC2183C19@magilla.sf.frob.com>
	<20110210181221.GA19413@win.tue.nl>
X-Windows: more than enough rope.
Message-Id: <20110210181720.475EE1806EE@magilla.sf.frob.com>
Date: Thu, 10 Feb 2011 10:17:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jan 25, 2011 at 09:45:15AM -0800, Roland McGrath wrote:
> 
> > the empty string has never been a valid relative pathname.
> 
> Hmm. I definitely recall otherwise.
> 
> The old Unix definition is that the empty string stands for "."
> so that 'ls ""' means the same as 'ls .'
> and 'ls /tmp/""' the same as 'ls /tmp/.'.

I'm aware of that.  I was talking about Linux and POSIX.


Thanks,
Roland
