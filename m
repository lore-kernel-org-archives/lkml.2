Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0LUHer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:34:47 -0500
Received: from canuck.infradead.org ([134.117.69.58]:32863 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab0LUHeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:34:46 -0500
Subject: Re: [RFC PATCH 00/15] Nohz task support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20101220233341.GA1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292859886.22905.22.camel@gandalf.stny.rr.com>
	 <20101220233341.GA1715@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 08:34:38 +0100
Message-ID: <1292916878.5021.170.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 00:33 +0100, Frederic Weisbecker wrote:
> So, we still need the syscalls slow path hooks.

Make it a cpuset property or something.
