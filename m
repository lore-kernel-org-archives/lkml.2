Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1AITiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 14:38:09 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:49649 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376Ab1AITiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 14:38:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPOYKU1GNBQZ/2dsb2JhbACkPHS6ZIVMBIRni00
Date: Sun, 9 Jan 2011 13:48:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
Message-ID: <20110109184802.GA32192@Krystal>
References: <cover.1294239591.git.jbaron@redhat.com> <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:47:10 up 277 days,  4:36,  5 users,  load average: 0.06, 0.08,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> Introduce:
> 
> static __always_inline bool static_branch(struct jump_label_key *key)
> 
> to replace the old JUMP_LABEL(key, label) macro.
> 
> The new static_branch(), simplifies the usage of jump labels. Since,
> static_branch() returns a boolean, it can be used as part of an if()
> construct. It also, allows us to drop the 'label' argument from the
> prototype. Its probably best understood with an example, here is the part
> of the patch that converts the tracepoints to use unlikely_switch():

small nit:

  s/unlikely_switch/arch_static_branch/g

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
