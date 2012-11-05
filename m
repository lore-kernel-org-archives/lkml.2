Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2KEPSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:18:49 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:17905 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520Ab2KEPSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:18:48 -0500
Date: Mon, 5 Nov 2012 15:18:47 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH 8/9] trace: use this_cpu_ptr per-cpu helper
In-Reply-To: <5094A2CB.8040208@gmail.com>
Message-ID: <0000013ad12707b8-ffc687fb-2ce2-41bc-93f7-86b17c1a2e02-000000@email.amazonses.com>
References: <50910A1E.3040009@gmail.com> <0000013ab7f1e47a-68c5ce3c-06bb-48f8-93f7-1ce012b36a75-000000@email.amazonses.com> <5093E5FF.5050000@gmail.com> <0000013ac24187fb-694b1865-baeb-4e3b-970e-50bdcd631de7-000000@email.amazonses.com>
 <5094A2CB.8040208@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, Shan Wei wrote:

> return (char *)this_cpu_ptr(&percpu_buffer->buffer);

Makes sense since buffer is the actual start of the bytes and not a
pointer to a buffer like what I thought.

