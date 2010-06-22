Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab0FVIoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:44:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:55759 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0FVIow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:44:52 -0400
Date: Tue, 22 Jun 2010 10:44:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Roland McGrath <roland@redhat.com>
Cc: Edward Allcutt <edward@allcutt.me.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: limit maximum concurrent coredumps
In-Reply-To: <20100622012303.BD72E402AD@magilla.sf.frob.com>
Message-ID: <alpine.LNX.2.00.1006221043470.13809@pobox.suse.cz>
References: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk> <20100622012303.BD72E402AD@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Roland McGrath wrote:

> A core dump is just an instance of a process suddenly reading lots of its
> address space and doing lots of filesystem writes, producing the kinds of
> thrashing that any such instance might entail.  

But priority settings don't apply any more for core dumping process, do 
they?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
