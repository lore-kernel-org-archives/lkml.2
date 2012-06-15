Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2FODDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:03:20 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54678 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab2FODDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:03:17 -0400
X-AuditID: b753bd60-98cf0ba000000f6c-3c-4fdaa5f37735
X-AuditID: b753bd60-98cf0ba000000f6c-3c-4fdaa5f37735
Message-ID: <4FDAA5F1.806@hitachi.com>
Date: Fri, 15 Jun 2012 12:03:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 04/13 v2] ftrace/x86_32: Push ftrace_ops in as
 3rd parameter to function tracer
References: <20120612224327.426900129@goodmis.org> <20120612225424.942411318@goodmis.org>
In-Reply-To: <20120612225424.942411318@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 7:43), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Add support of passing the current ftrace_ops into the 3rd parameter
> of the callback to the function tracer.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
