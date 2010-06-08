Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0FHITB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:19:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59903 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227Ab0FHIS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:18:57 -0400
Date: Tue, 8 Jun 2010 09:25:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Valdis.Kletnieks@vt.edu,
       Dave Young <hidave.darkstar@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, tytso@mit.edu
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100608092554.34e9296f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100607210618.GI6839@outflux.net>
References: <20100603080158.GE4971@outflux.net>
	<m11vcnlw9j.fsf@fess.ebiederm.org>
	<20100603210051.GD4714@outflux.net>
	<6305.1275927536@localhost>
	<20100607164257.GD6839@outflux.net>
	<m1631ug05u.fsf@fess.ebiederm.org>
	<20100607210618.GI6839@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For the people objecting to the actual code of the patch, I'm very
> interested in finding a solution.  I am obviously not a Linux kernel VFS
> maintainer.  I'm very keen to find an acceptable version of the patch
> based on feedback from those that know this area of the kernel intimately.

You've already had those suggestions some days ago. Use a security module,
either by using something like SELinux (where you can do this just fine
as far as I can see including exceptions by label for problem apps), or
write your own little seucrity module that does it. Or for that matter
just leave it as an Ubuntu patch.

Since you didn't seem t get the hint earlier I also suspecifically NAK the
current patch.

Alan
