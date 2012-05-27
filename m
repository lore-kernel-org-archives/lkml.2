Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2E0PIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 11:08:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46121 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2E0PIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 11:08:48 -0400
Date: Sun, 27 May 2012 17:08:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
Message-ID: <20120527150841.GO27374@one.firstfloor.org>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com> <20120525223646.GL27374@one.firstfloor.org> <20120526123858.GA1679@m.brq.redhat.com> <CAOPLpQfveNoXkorqfk=zSp72-YXskxtDebJqhGarngaJY89Rmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOPLpQfveNoXkorqfk=zSp72-YXskxtDebJqhGarngaJY89Rmg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> same counters over and over again (e.g., cycle count, instruction
> count, etc).  Therefore it is important to recognize when two groups

These two are luckily fixed counters, so always available
(at least as long as you disable the nmi watchdog)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
