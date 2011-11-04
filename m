Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1KDMIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:08:46 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:55645 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1KDMIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:08:45 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: David Smith <dsmith@redhat.com>
Subject: Re: [RFC PATCH v2] Tracepoint: add exec tracepoint
Date: Fri, 4 Nov 2011 12:08:37 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-12-generic; KDE/4.7.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <4EB2BA74.5070207@redhat.com>
In-Reply-To: <4EB2BA74.5070207@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111041208.38163.pedro@codesourcery.com>
X-OriginalArrivalTime: 04 Nov 2011 12:08:41.0530 (UTC) FILETIME=[7E1609A0:01CC9AEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 November 2011 15:59:48, David Smith wrote:
> +                               if (depth == 0) {
> +                                       trace_sched_process_exec(current, bprm);
>                                         ptrace_event(PTRACE_EVENT_EXEC,
>                                                         old_pid);
> +                               }

Won't tracepoints be interested in the old pid as well?  Or does bprm
carry that info?  That was only recently added to the ptrace event,
which probably postdates your original patch.

-- 
Pedro Alves
