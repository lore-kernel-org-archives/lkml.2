Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1BKJME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 04:12:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab1BKJMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 04:12:02 -0500
From: Andreas Schwab <schwab@redhat.com>
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Roland McGrath <roland@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linasvepstas@gmail.com, Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
	<201101251529.24779.arnd@arndb.de>
	<20110125174515.C1DC2183C19@magilla.sf.frob.com>
	<20110210181221.GA19413@win.tue.nl>
X-Yow: You mean now I can SHOOT YOU in the back and further BLUR
 th' distinction between FANTASY and REALITY?
Date: Fri, 11 Feb 2011 10:11:39 +0100
In-Reply-To: <20110210181221.GA19413@win.tue.nl> (Andries Brouwer's message of
	"Thu, 10 Feb 2011 19:12:21 +0100")
Message-ID: <m34o8bq6k4.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andries Brouwer <aebr@win.tue.nl> writes:

> and 'ls /tmp/""' the same as 'ls /tmp/.'.

/tmp/"" is not an empty file name, and it is indistinguishable from /tmp/ .

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
