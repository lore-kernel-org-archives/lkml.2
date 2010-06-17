Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab0FQXLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:11:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47279 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab0FQXLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:11:43 -0400
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-doc@vger.kernel.org, Linux Containers <containers@lists.osdl.org>
References: <20100616221833.GM24749@outflux.net>
	<m1hbl1eta6.fsf@fess.ebiederm.org>
	<20100617165940.GU24749@outflux.net>
	<m1typ175ip.fsf@fess.ebiederm.org> <20100617225043.GA2492@hallyn.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 17 Jun 2010 16:11:27 -0700
In-Reply-To: <20100617225043.GA2492@hallyn.com> (Serge E. Hallyn's message of "Thu\, 17 Jun 2010 17\:50\:43 -0500")
Message-ID: <m1hbl1p84g.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: serge@hallyn.com, containers@lists.osdl.org, linux-doc@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu, dhowells@redhat.com, hpa@zytor.com, oleg@redhat.com, roland@redhat.com, schwidefsky@de.ibm.com, hidave.darkstar@gmail.com, jkosina@suse.cz, akpm@linux-foundation.org, rdunlap@xenotime.net, linux-kernel@vger.kernel.org, kees.cook@canonical.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> Kees Cook <kees.cook@canonical.com> writes:
>> Somewhere Serge has a git tree where he started making the capabilities
>
> FWIW I believe the latest one is
>
> 	http://git.kernel.org/?p=linux/kernel/git/sergeh/linux-cr.git;a=shortlog;h=refs/heads/userns.feb16.1

Cool.

> I (/we) should get back to that...  Though waiting for certain other
> bits to settle (i.e. tagged sysfs and user-ns-safe SCM_CREDENTIALS)
> isn't a bad thing.

Tagged sysfs is in 2.6.35-rc1+
user-ns-safe SCM_CREDENTIALS have merged to net-next.

ns_capable seems to be the next piece easy piece of the user_namespace.

Eric
