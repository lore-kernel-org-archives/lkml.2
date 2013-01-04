Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3ADMNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 07:13:51 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:58954 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3ADMNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 07:13:48 -0500
Message-ID: <50E6C776.7060707@mvista.com>
Date: Fri, 04 Jan 2013 16:13:42 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Srivatsa Vaddagiri <vatsa@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, mhocko@suse.cz, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/2] Revert "nohz: Fix idle ticks in cpu summary line
 of /proc/stat" (commit 7386cdbf2f57ea8cff3c9fde93f206e58b9fe13f).
References: <1357268337-8025-1-git-send-email-vatsa@codeaurora.org>
In-Reply-To: <1357268337-8025-1-git-send-email-vatsa@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04-01-2013 6:58, Srivatsa Vaddagiri wrote:

> With offline cpus no longer beeing seen in nohz mode (ts->idle_active=0), we
> don't need the check for cpu_online() introduced in commit 7386cdbf. Offline

    Please also specify the summary of that commit in parens (or however you 
like).

> cpu's idle time as last recorded in its ts->idle_sleeptime will be reported
> (thus excluding its offline time as part of idle time statistics).

> Cc: mhocko@suse.cz
> Cc: srivatsa.bhat@linux.vnet.ibm.com
> Signed-off-by: Srivatsa Vaddagiri <vatsa@codeaurora.org>

WBR, Sergei

