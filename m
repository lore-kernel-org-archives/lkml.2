Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1AFS6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:58:48 -0500
Received: from xenotime.net ([72.52.115.56]:34534 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752337Ab1AFS6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:58:47 -0500
Date: Thu, 6 Jan 2011 10:58:45 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] TRACE_EVENT: gradual semicolumn removal
Message-Id: <20110106105845.6b1ec41b.rdunlap@xenotime.net>
In-Reply-To: <20110106184732.GB2526@Krystal>
References: <20110106184732.GB2526@Krystal>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 13:47:32 -0500 Mathieu Desnoyers wrote:

> This patch initiates the removal of the extra semicolumns at the end of:

Please s/semicolumn/semicolon/ globally.

ta.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
