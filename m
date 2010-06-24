Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0FXMCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:02:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0FXMCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:02:49 -0400
Message-ID: <4C234961.4060109@suse.cz>
Date: Thu, 24 Jun 2010 14:02:41 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       WANG Cong <xiyou.wangcong@gmail.com>, John Kacur <jkacur@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 16/40] tags: recognize compat syscalls
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-17-git-send-email-imunsie@au1.ibm.com>
In-Reply-To: <1277287401-28571-17-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.6.2010 12:02, Ian Munsie wrote:
> From: Jason Baron <jbaron@redhat.com>
> 
> make tags.sh recognize the new syscall macros:
> 
> COMPAT_SYSCALL_DEFINE#N()
> ARCH_COMPAT_SYSCALL_DEFINE#N()
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>

Acked-by: Michal Marek <mmarek@suse.cz>

Michal
