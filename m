Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0FXMFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:05:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:35578 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab0FXMFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:05:21 -0400
Message-ID: <4C2349F3.7090207@suse.cz>
Date: Thu, 24 Jun 2010 14:05:07 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel,gmane.linux.ports.ppc64.devel,gmane.linux.file-systems,gmane.linux.kernel.kexec,gmane.linux.network
To: Andi Kleen <ak@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ian Munsie <imunsie@au1.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Moyer <jmoyer@redhat.com>, David Howells <dhowells@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Biederman <ebiederm@xmission.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       WANG Cong <amwang@redhat.com>, "Sam Ravnborg"@suse.de
Subject: Re: [PATCH 31/40] trace syscalls: Convert various generic compat
 syscalls
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-32-git-send-email-imunsie@au1.ibm.com> <4C21DFBA.2070202@linux.intel.com> <20100623102931.GB5242@nowhere> <4C21E3F8.9000405@linux.intel.com>
In-Reply-To: <4C21E3F8.9000405@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.6.2010 12:37, Andi Kleen wrote:
> It also has maintenance costs, e.g. I doubt ctags and cscope
> will be able to deal with these kinds of macros, so it has a
> high cost for everyone using these tools.

FWIW, patch 16/40 of this series teaches 'make tags' to recognize these
macros: http://permalink.gmane.org/gmane.linux.kernel/1002103

Michal
