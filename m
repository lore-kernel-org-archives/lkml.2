Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab0LOQkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:40:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:33409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0LOQkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:40:42 -0500
Message-ID: <4D08EF4E.8070403@kernel.org>
Date: Wed, 15 Dec 2010 17:39:42 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com>
In-Reply-To: <4D08EE57.8010602@zytor.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 16:39:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/15/2010 05:35 PM, H. Peter Anvin wrote:
> I think we can do that... let me look through the tree first officially
> committing.  Alternatively, I can pull the patches from your tree and
> individually review them and add them to a tip branch, if you prefer.

I'd prefer percpu things going through percpu tree, if for nothing
else for git history's sake, but I don't think it really matters.  The
series is spread all over the place anyway.  As long as each
maintainer is properly alerted about the changes, it should be okay.
Please let me know whether you agree with the changes currently queued
in percpu#for-next.  I'll update the tree with your Acked-by's and
freeze it.

Thanks.

-- 
tejun
