Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab0JQTiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 15:38:15 -0400
Received: from mail.perches.com ([173.55.12.10]:3001 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540Ab0JQTiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 15:38:14 -0400
Subject: Re: [PATCH] checkpatch: allow single space before labels
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1287343839.1998.699.camel@laptop>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
	 <1287303678.20968.37.camel@Joe-Laptop>
	 <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
	 <1287310889.1998.153.camel@laptop>  <1287334498.20968.53.camel@Joe-Laptop>
	 <1287343839.1998.699.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 12:38:12 -0700
Message-ID: <1287344292.20968.65.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 21:30 +0200, Peter Zijlstra wrote:
> On Sun, 2010-10-17 at 09:54 -0700, Joe Perches wrote:
> > There are a half dozen or so in sched.c
> 
> Unlike some people, I've actually got something better to do than
> whitespace patches.. they'll change next time the code in question needs
> to change.

It takes as much time to reply as to change them.

perl -p -i -e 's/^ (\w+):/$1:/g' kernel/sched.c


