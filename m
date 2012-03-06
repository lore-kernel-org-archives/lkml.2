Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030665Ab2CFN3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:29:01 -0500
Received: from mx2.parallels.com ([64.131.90.16]:38686 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965097Ab2CFN3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:29:00 -0500
Message-ID: <4F5610D3.2030907@parallels.com>
Date: Tue, 6 Mar 2012 17:27:47 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Miao Xie <miaox@cn.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RFC PATCH] checkpatch: Warn on use of yield()
References: <20120302112358.GA3481@suse.de>   <1330723262.11248.233.camel@twins>   <20120305121804.3b4daed4.akpm@linux-foundation.org>   <1330999280.10358.3.camel@joe2Laptop> <1331037942.11248.307.camel@twins>  <4F560DA8.5040302@parallels.com> <1331040318.11248.311.camel@twins>
In-Reply-To: <1331040318.11248.311.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 05:25 PM, Peter Zijlstra wrote:
> On Tue, 2012-03-06 at 17:14 +0400, Glauber Costa wrote:
>>
>> Can't we point people to some Documentation file that explains the
>> alternatives?
>
> Not sure that's a finite set.. however I think we covered the most
> popular ones in this thread. One could use a lkml.kernel.org link.
>
Yes, I think that would work. Summarizing your arguments in an in-tree 
Documentation file would be good as well, IMHO.
