Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2JQCr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:47:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:32839 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2JQCr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:47:56 -0400
X-AuditID: b753bd60-96850ba000002f78-39-507e1c59abc9
X-AuditID: b753bd60-96850ba000002f78-39-507e1c59abc9
Message-ID: <507E1C49.1030002@hitachi.com>
Date: Wed, 17 Oct 2012 11:47:37 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -tip 2/4] tracing: add a resize function for making one
 buffer equivalent to the other buffer
References: <20121002081309.8661.37629.stgit@falsita>	 <20121002082715.9807.90791.stgit@falsita> <1349456348.6755.59.camel@gandalf.local.home>
In-Reply-To: <1349456348.6755.59.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

I'm sorry for my late reply.
(I was outside the office for business trip.)

(2012/10/06 1:59), Steven Rostedt wrote:
 >> +/* resize @tr's buffer to the size of @size_tr's entries */
 >> +static int resize_buffer_even(struct trace_array *tr,
 >
 > I don't mind this patch, but I just hate the name "resize_buffer_even".
 > What about "resize_buffer_duplicate_size"?
 >

O.K.
I'll send modified version of this patch later.

Regards,
Hiraku Toyooka
