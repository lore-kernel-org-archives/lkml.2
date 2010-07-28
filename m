Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab0G1VJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:09:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46214
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053Ab0G1VJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:09:31 -0400
Date: Wed, 28 Jul 2010 14:09:48 -0700 (PDT)
Message-Id: <20100728.140948.22055750.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 00/12] jump label v10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100728204225.GB28992@redhat.com>
References: <20100728201459.GA28992@redhat.com>
	<20100728.132427.35841081.davem@davemloft.net>
	<20100728204225.GB28992@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>
Date: Wed, 28 Jul 2010 16:42:26 -0400

> Not sure exactly what your .config is,

arch/sparc/configs/sparc64_defconfig with tracepoints and the function
graph tracer enabled

> but pulling in jump_label.h explicitly into kprobes.c should fix
> that.

Yes, it does.
