Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2BTWsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 17:48:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38524 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab2BTWsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 17:48:24 -0500
Message-ID: <4F42CD93.2030605@zytor.com>
Date: Mon, 20 Feb 2012 14:47:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, mingo@elte.hu, davem@davemloft.net,
        ddaney.cavm@gmail.com, pjt@google.com, rth@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4][RFC] jump label: introduce default true branch
References: <cover.1324493360.git.jbaron@redhat.com>
In-Reply-To: <cover.1324493360.git.jbaron@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 11:09 AM, Jason Baron wrote:
> Hi Peter,
> 
> I've introduced a new static_branch_def_true() construct, such that the straight
> line path is the true branch, and we patch a jump to get to the false branch.
> In order to make jump_label_inc()/dec() work as 'make true'/'make false' with
> counting, I've had to update some of the core jump label code. This patchset also
> introduces: JUMP_LABEL_INIT_TRUE/FALSE, so that keys should be initialized as:
> 
> struct jump_label_key true_key = JUMP_LABEL_INIT_TRUE;
> 
>            or
> 
> struct jump_label_key false_key = JUMP_LABEL_INIT_FALSE;
> 
> I think this patch series should address the issues that came up with sched_feat()
> implementation.
> 

Hi,

Did this ever get addressed?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

