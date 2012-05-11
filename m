Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab2EKI3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:29:23 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33682 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2EKI3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:29:20 -0400
X-AuditID: b753bd60-942caba000000f4e-20-4faccddc39e5
X-AuditID: b753bd60-942caba000000f4e-20-4faccddc39e5
Message-ID: <4FACCDDB.4080801@hitachi.com>
Date: Fri, 11 May 2012 17:29:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Frank Ch. Eigler" <fche@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip ] x86/kprobes: kprobes call optimization
References: <4FAA32B3.3070806@hitachi.com> <20120510115401.18125.93504.stgit@localhost.localdomain>
In-Reply-To: <20120510115401.18125.93504.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/10 20:54), Masami Hiramatsu wrote:
> Note: this code is still under development, but it will
> be useful for the discussion to show this.
> 
> Use relative call instead of relative jump for optimizing
> kprobes. This reduces x86-depend magic code and runtime
> memory size.

Hmm, I've found that this patch may increase the execution
time of probing more than 20%. I think that is more than
acceptable...


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
