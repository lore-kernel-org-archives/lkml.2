Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0JEQtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:49:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:45616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab0JEQtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:49:51 -0400
Message-ID: <4CAB5779.5020901@kernel.org>
Date: Tue, 05 Oct 2010 18:51:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Yang Ruirui <ruirui.r.yang@tieto.com>,
        Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>
Subject: Re: -mm: xfs lockdep warning
References: <201009161546.16909.ruirui.r.yang@tieto.com>	<20100917005227.GJ24409@dastard>	<20100920191355.GA28443@infradead.org>	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>	<4CA997DF.5030008@kernel.org>	<20101004092107.GJ4681@dastard> <AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>
In-Reply-To: <AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 16:48:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is getting confusing.

On 10/05/2010 12:09 PM, Torsten Kaiser wrote:
> 2) the hang with 2.6.35-rc5 I have seen twice (triggered probably by
> high load while building KOffice on an tmpfs)

The trace doesn't seem to firmly point at xfs locking up.  There are
md and dm crypt involved.  Are you sure this is locking up inside xfs?
Also, can you please enable frame pointers so that we can get more
reliable backtrace?

> 3) the lockdep issue that started this thread and that I am seeing in
> mainline 2.6.36-rc5 and -rc6 and that seems to be rather easy to
> trigger for me.
> 
> Because 3) is regarded as a false positive, it should not be the cause
> of 2)

For now, let's not draw any conclusion or mix the issues.  I'll look
up the original thread and look into what the lockdep warning means.

Thanks.

-- 
tejun
