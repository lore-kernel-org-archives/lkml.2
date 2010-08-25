Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0HYEql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:46:41 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51065 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0HYEqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:46:39 -0400
Message-ID: <4C74A01E.1060809@cs.helsinki.fi>
Date: Wed, 25 Aug 2010 07:46:22 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
References: <20100824120714.8918f8de.sfr@canb.auug.org.au>	<4C740450.3030000@cs.helsinki.fi> <20100825101320.bed89b2a.sfr@canb.auug.org.au>
In-Reply-To: <20100825101320.bed89b2a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.8.2010 3.13, Stephen Rothwell wrote:
> Hi Pekka,
>
> On Tue, 24 Aug 2010 20:41:36 +0300 Pekka Enberg<penberg@cs.helsinki.fi>  wrote:
>>
>> Thanks for the report. The problem should be fixed by this commit:
>>
>> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=5792949c540c9fd719c3fc0d6edc97374222e792
>
> A small point:  I did *not* review that patch.  I *did* report the bug
> (and seemingly provided the commit message).

Oh, sorry about that.

> Thanks for the build fix.

I dropped slub cleanups from -next until we've resolved the UP boot time 
crash problem.
