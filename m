Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0FQWu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:50:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab0FQWuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:50:25 -0400
X-Authority-Analysis: v=1.1 cv=zLGBfXKW/yOQN1c4qTdQUWouaSiWOaUUjRgOJi1LSJI= c=1 sm=0 a=_xeo1-vZUxgA:10 a=hO-oPbc3tlwA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=PtDNVHqPAAAA:8 a=DfNHnWVPAAAA:8 a=VwQbUJbxAAAA:8 a=aE8EK1j978rNxSVWQakA:9 a=VzbKQJXbwgBoQsoeUeiJt_PW80MA:4 a=CjuIK1q_8ugA:10 a=wYE_KDyynt4A:10 a=lBRciGGoxdUA:10 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Thu, 17 Jun 2010 17:50:43 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-doc@vger.kernel.org, Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100617225043.GA2492@hallyn.com>
References: <20100616221833.GM24749@outflux.net>
 <m1hbl1eta6.fsf@fess.ebiederm.org>
 <20100617165940.GU24749@outflux.net>
 <m1typ175ip.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1typ175ip.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Kees Cook <kees.cook@canonical.com> writes:
> Somewhere Serge has a git tree where he started making the capabilities

FWIW I believe the latest one is

	http://git.kernel.org/?p=linux/kernel/git/sergeh/linux-cr.git;a=shortlog;h=refs/heads/userns.feb16.1

I (/we) should get back to that...  Though waiting for certain other
bits to settle (i.e. tagged sysfs and user-ns-safe SCM_CREDENTIALS)
isn't a bad thing.

-serge
