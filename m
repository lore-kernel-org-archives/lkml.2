Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0JQQzB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 12:55:01 -0400
Received: from mail.perches.com ([173.55.12.10]:2991 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371Ab0JQQzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 12:55:00 -0400
Subject: Re: [PATCH] checkpatch: allow single space before labels
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1287310889.1998.153.camel@laptop>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
	 <1287303678.20968.37.camel@Joe-Laptop>
	 <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
	 <1287310889.1998.153.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 09:54:58 -0700
Message-ID: <1287334498.20968.53.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 12:21 +0200, Peter Zijlstra wrote:
> On Sun, 2010-10-17 at 04:24 -0400, Mike Frysinger wrote:
> > feel free to extend however as long as the end result is no warnings
> > for " foo:" ;).
> I utterly detest those indented labels and am eradicating them wherever
> I notice them. There's really no sane reason to use them what so ever.
> Diff can be taught not to get confused about them, see my earlier email.

Your choice.

There are a half dozen or so in sched.c

There are 5000 or so single space indented labels.
There are 35000 or so labels without any indent.

His choice too no?

