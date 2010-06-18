Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379Ab0FRKzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:55:14 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:64849 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab0FRKzM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:55:12 -0400
X-AuditID: 1209190e-b7b82ae000005260-8a-4c1b508e85aa
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4C1AE3A8.2020104@schaufler-ca.com>
Date: Fri, 18 Jun 2010 06:54:57 -0400
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kees Cook <kees.cook@canonical.com>,
       Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E1FEE555-566E-4698-8FD8-240076A4F850@mit.edu>
References: <20100616221833.GM24749@outflux.net>	<20100617000120.13071be8@lxorguk.ukuu.org.uk>	<20100616232230.GP24749@outflux.net>	<alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>	<20100617170453.GV24749@outflux.net>	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>	<20100617140630.c6ced27a.rdunlap@xenotime.net>	<20100617221815.68ce30c5@lxorguk.ukuu.org.uk>	<20100617215105.GB24749@outflux.net> <20100617233054.330256cf@lxorguk.ukuu.org.uk> <4C1AE3A8.2020104@schaufler-ca.com>
To: Casey Schaufler <casey@schaufler-ca.com>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i think we really need to have stacked LSM's, because there is a large set
of people who will never use SELinux.  Every few years, I take another 
look at SELinux, my head explodes with the (IMHO unneeded complexity),
and I go away again...

Yet I would really like a number of features such as this ptrace scope idea ---
which I think is a useful feature, and it may be that stacking is the only
way we can resolve this debate.   The SELinux people will never believe that
their system is too complicated, and I don't like using things that are impossible
for me to understand or configure, and that doesn't seem likely to change anytime
in the near future.

I mean, even IPSEC RFC's are easier for me to understand, and that's saying
a lot...

-- Ted

