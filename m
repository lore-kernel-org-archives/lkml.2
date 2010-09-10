Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0IJPAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:00:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:39538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab0IJPAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:00:54 -0400
Message-ID: <4C8A47E7.8080102@kernel.org>
Date: Fri, 10 Sep 2010 16:59:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] percpu: use percpu allocator on UP too
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org> <4C74DB05.7000101@cs.helsinki.fi> <alpine.DEB.2.00.1008250846590.13026@router.home> <4C762734.1030402@kernel.org> <4C8121BC.7040609@kernel.org> <4C81ED2C.6000304@cs.helsinki.fi> <4C8215B9.8060606@kernel.org> <4C87548D.5080202@kernel.org>
In-Reply-To: <4C87548D.5080202@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 14:59:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2010 11:17 AM, Tejun Heo wrote:
> On 09/04/2010 11:47 AM, Tejun Heo wrote:
>> Hello,
>>
>> On 09/04/2010 08:54 AM, Pekka Enberg wrote:
>>> Is this going into some public append-only branch I could
>>> cherry-pick the changeset from to my 'slub/cleanups' branch?
>>
>> I'll put it into percpu#for-next once Linus pulls in the currently
>> pending set of fixes.  I'll let you know.
> 
> Alright, now in percpu#for-next tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next
> 
> The branch currenly contains only those three patches, so please feel
> free to pull from it.

Branch updated to fix build for s390 and add missing memory clearing
for km- allocator.  You'll at least want to pull upto commit
fc1481a956181d0360d3eb129965302489895a1b.

Thanks.

-- 
tejun
