Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab0LPUou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:44:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42280 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0LPUot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:44:49 -0500
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, athieu.desnoyers@polymtl.ca,
        hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <20101216203603.GA15610@Krystal>
References: <cover.1292522251.git.jbaron@redhat.com>
	 <a35b9310aafa31a9e97f5c9bad9b09e0b6cbbf79.1292522252.git.jbaron@redhat.com>
	 <1292526602.2708.57.camel@laptop> <20101216192303.GB2856@redhat.com>
	 <1292528031.2708.77.camel@laptop> <20101216193635.GC2856@redhat.com>
	 <1292528501.2708.80.camel@laptop> <20101216194852.GD2856@redhat.com>
	 <20101216203603.GA15610@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 21:43:41 +0100
Message-ID: <1292532221.2708.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:36 -0500, Mathieu Desnoyers wrote:
> Tracepoints keep their own reference counts for enable/disable, so a
> simple "enable/disable" is fine as far as tracepoints are concerned. Why
> does perf need that refcounting done by the static jumps ?

Because the refcount is all we have... Why not replace that tracepoint
refcount with the jumplabel thing?
