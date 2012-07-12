Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162452Ab2GLWwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:52:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162275Ab2GLWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 163/187] tracing: change CPU ring buffer state from tracing_cpumask
Date: Thu, 12 Jul 2012 15:35:19 -0700
Message-Id: <20120712191538.459469045@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

commit 71babb2705e2203a64c27ede13ae3508a0d2c16c upstream.

According to Documentation/trace/ftrace.txt:

tracing_cpumask:

        This is a mask that lets the user only trace
        on specified CPUS. The format is a hex string
        representing the CPUS.

The tracing_cpumask currently doesn't affect the tracing state of
per-CPU ring buffers.

This patch enables/disables CPU recording as its corresponding bit in
tracing_cpumask is set/unset.

Link: http://lkml.kernel.org/r/1336096792-25373-3-git-send-email-vnagarnaik@google.com

