Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2CEPwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:52:38 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50590 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab2CEPwh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:52:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.152.145.135 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <20120305154753.GA14604@elte.hu>
References: <20120224094048.GA7952@quad>
	<20120305154753.GA14604@elte.hu>
Date: Mon, 5 Mar 2012 16:52:35 +0100
Message-ID: <CABPqkBRRbWOMOOfxNgOVkt+kfTWA8Uqeo5VzvPhj+PCLBc7SZw@mail.gmail.com>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        asharma@fb.com, robert.richter@amd.com, ming.m.lin@intel.com,
        vweaver1@eecs.utk.edu, andi@firstfloor.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 4:47 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>
> Another usability bug of the new branch sampling feature is that
> typing the obvious:
>
>  $ perf record -b ./myprog
>
> does not do the obvious thing and default to 'any' but throws a
> *very* unhelpful generic perf error:
>
Fair enough. I can add code  to handle this case.

>
>  usage: perf record [<options>] [<command>]
>    or: perf record [<options>] -- <command> [<options>]
>
>  ...
>
> Really, we should do better than this. Only people who *want* to
> specify finer LBR filters should be forced to specify them.
>
> Thanks,
>
>        Ingo
