Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1BHCLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:11:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab1BHCK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:10:58 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=QP3UcCmQUFsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FuEHKrtunM1nccgp1RgA:9 a=veSzko8-Pn6Azac6xORrvnaHcjoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: PowerPC, ftrace: Add PPC raw syscall tracepoints & ftrace
 fixes (mimimal subset only) v4
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Jason Baron <jbaron@redhat.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alexander Graf <agraf@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, Nathan Lynch <ntl@pobox.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        David Gibson <dwg@au1.ibm.com>, Andreas Schwab <schwab@linux-m68k.org>,
        Namhyung Kim <namhyung@gmail.com>
In-Reply-To: <1296703645-18718-1-git-send-email-imunsie@au1.ibm.com>
References: <1296703645-18718-1-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 07 Feb 2011 21:10:56 -0500
Message-ID: <1297131056.23343.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 14:27 +1100, Ian Munsie wrote:
> Hi All,
> 
> This is a partial version of my 'ftrace syscalls, PowerPC: Various fixes,
> Compat Syscall support and PowerPC implementation'. This is updated from
> yesterday with arch_syscall_addr changed to a static inline function from
> Steven's suggestion.
> 
> This subset implements the raw syscall tracepoints on PowerPC which has been
> requested recently.  It also fixes ftrace syscalls to ensure that events will
> only be created for syscalls that successfully map their metadata to a syscall
> number, so that non-working phantom events are not created. Patches #2 and #6
> in this series are not strictly necessary for this, they just optimise ftrace
> syscalls a bit.
> 
> What's missing from this series that was in the full 40 patch v2 series is the
> conversion of all the syscalls implemented under /arch/powerpc, Jason Baron's
> compat syscall support and the conversion of the remaining native and compat
> syscalls to this infrastructure.

Thanks Ian,

I'll pull this into my local repo and start running my tests on it.

-- Steve


