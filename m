Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1DGO4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:56:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46365 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1DGO4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:56:40 -0400
Message-ID: <4D9DD08C.2080101@zytor.com>
Date: Thu, 07 Apr 2011 07:56:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: tip: New "Link:" tag to replace "LKML-Reference:"
References: <4D9CE4AE.4090303@zytor.com> <1302185312.3329.1240.camel@twins>	 <4D9DCDAB.9000707@zytor.com> <1302188050.9086.27.camel@twins>
In-Reply-To: <1302188050.9086.27.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 07:54 AM, Peter Zijlstra wrote:
> 
> Can't we use a prepare-commit-msg or commit-msg hook to re-write the
> commit message to include a Link tag when one is missing, using
> something like:
> 
> Link: http://lkml.kernel.org/r/tip-$SHA@git.kernel.org
> 
> And have the post-commit hook that sends the messages recognize this
> form and send the message using the correct msgid.
> 
> That way the commit includes a correct and clickable link, doesn't
> require magic knowledge and doesn't need the committer to do extra work.
> 

Think about it... hint: the SHA1 is a cryptographically secure signature
of the commit object.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

