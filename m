Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2JICIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:08:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48166 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2JICIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:08:34 -0400
X-AuditID: b753bd60-945e1ba000004744-8b-507387174c83
X-AuditID: b753bd60-945e1ba000004744-8b-507387174c83
Message-ID: <50738708.1020900@hitachi.com>
Date: Tue, 09 Oct 2012 11:08:08 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v5 1/3] tracing,x86: Add a TSC trace_clock
References: <1349148680-9509-1-git-send-email-dhsharp@google.com>
In-Reply-To: <1349148680-9509-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

This is a nice patch set.

I just have found something should be fixed, which related to
your work. I'll send it following this mail.

Would you mind adding these patches as your patch series?

Thanks,

Yoshihiro YUNOMAE

(2012/10/02 12:31), David Sharp wrote:
> In order to promote interoperability between userspace tracers and ftrace,
> add a trace_clock that reports raw TSC values which will then be recorded
> in the ring buffer. Userspace tracers that also record TSCs are then on
> exactly the same time base as the kernel and events can be unambiguously
> interlaced.
> 

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


