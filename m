Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1KGP5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:57:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab1KGP5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:57:49 -0500
Message-ID: <4EB7FFEA.6070409@redhat.com>
Date: Mon, 07 Nov 2011 09:57:30 -0600
From: David Smith <dsmith@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH v2] Tracepoint: add exec tracepoint
References: <4EB2BA74.5070207@redhat.com> <1320670609.18053.32.camel@twins>
In-Reply-To: <1320670609.18053.32.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 06:56 AM, Peter Zijlstra wrote:

> On Thu, 2011-11-03 at 10:59 -0500, David Smith wrote:
>> Added general purpose exec tracepoint.  The 'bprm' argument gives
>> details of the exec.

>>

> This 'changelog' if one can call it that, is completely devoid of
> rationale, why should we care and why should we merge.


Sorry for being too terse.

Exec is an important major event in the life of a task (like fork or
exit).  If you want to watch a task start up, when it gets exec'ed is a
good place to start.  With the addition of this tracepoint, we can
monitor exec's and get a better picture of system activity in general.
This will also enable better process tracking, allowing you to answer
questions like "what process keeps starting up process X?".

This tracepoint can also be useful in ftrace filtering (i.e. starting or
stopping filtering when exec is called)

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
