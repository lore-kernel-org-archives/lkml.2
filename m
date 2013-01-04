Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3ADToS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:44:18 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:36428 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab3ADToP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:44:15 -0500
Message-ID: <50E73EB6.9090100@mvista.com>
Date: Fri, 04 Jan 2013 23:42:30 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
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
References: <1357268337-8025-1-git-send-email-vatsa@codeaurora.org> <50E6C776.7060707@mvista.com> <20130104192934.GB29866@quicinc.com>
In-Reply-To: <20130104192934.GB29866@quicinc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/04/2013 10:29 PM, Srivatsa Vaddagiri wrote:

>>> With offline cpus no longer beeing seen in nohz mode (ts->idle_active=0), we
>>> don't need the check for cpu_online() introduced in commit 7386cdbf. Offline

>>    Please also specify the summary of that commit in parens (or
>> however you like).

> I had that in Subject line, but yes would be good to include in commit message
> as well. I will incorporate that change alongwith anything else required in
> next version of this patch.

   Ah, that was a revert with atypical subject -- didn't notice. Then there's no
need to specify it twice.

> - vatsa

WBR, Sergei

