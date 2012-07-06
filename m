Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab2GFR1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:27:43 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57533 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab2GFR1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:27:42 -0400
Message-ID: <4FF7200B.5060008@gmail.com>
Date: Fri, 06 Jul 2012 11:27:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: perf lock record fails
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What config options need to be enabled for 'perf lock record' to work? I 
tried a number of custom builds and stock Fedora kernels. I always get:

$ perf lock record -- sleep 1
invalid or unsupported event: 'lock:lock_acquire'

Though trace_lock_acquire exists, CONFIG_LOCKDEP is set, and ftrace is 
enabled.

What am I missing?

David

