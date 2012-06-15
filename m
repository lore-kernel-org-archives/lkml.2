Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2FODCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:02:35 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38314 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2FODCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:02:34 -0400
X-AuditID: b753bd60-a2688ba000000655-45-4fdaa5c7bf83
X-AuditID: b753bd60-a2688ba000000655-45-4fdaa5c7bf83
Message-ID: <4FDAA5C4.4070005@hitachi.com>
Date: Fri, 15 Jun 2012 12:02:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 01/13 v2] ftrace: Pass ftrace_ops as third parameter
 to function trace callback
References: <20120612224327.426900129@goodmis.org> <20120612225424.267254552@goodmis.org>
In-Reply-To: <20120612225424.267254552@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 7:43), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Currently the function trace callback receives only the ip and parent_ip
> of the function that it traced. It would be more powerful to also return
> the ops that registered the function as well. This allows the same function
> to act differently depending on what ftrace_ops registered it.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

looks good to me :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
