Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1DQRuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 13:50:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49582 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1DQRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 13:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xl7RQml/jgRaJX3bYOHqgS1ff51zpqZSe73As7mL5DKkkksc4qx33AdIyoypRtmNZM
         +q4rn/g8nLDJVFA0zs8lU7X59FzjTQzuIcO8nbE89/JbUnektKQtnjYaOIoFR4y63mvZ
         Y9kjMnnLoA0vGNCw2tqYwB10Frf1JKkf73/vM=
Message-ID: <4DAB26F6.40407@gmail.com>
Date: Sun, 17 Apr 2011 19:44:22 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] IO-less dirty throttling v7
References: <20110416132546.765212221@intel.com> <4DAA976A.3080007@gmail.com> <20110417093048.GA4027@localhost>
In-Reply-To: <20110417093048.GA4027@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/04/2011 11:30, Wu Fengguang ha scritto:
> On Sun, Apr 17, 2011 at 03:31:54PM +0800, Marco Stornelli wrote:
>> Il 16/04/2011 15:25, Wu Fengguang ha scritto:
>>> Andrew,
>>>
>>> This revision undergoes a number of simplifications, cleanups and fixes.
>>> Independent patches are separated out. The core patches (07, 08) now have
>>> easier to understand changelog. Detailed rationals can be found in patch 08.
>>>
>>> In response to the complexity complaints, an introduction document is
>>> written explaining the rationals, algorithm and visual case studies:
>>>
>>> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/slides/smooth-dirty-throttling.pdf
>>
>> It'd be great if you wrote a summary in the kernel documentation.
>
> Perhaps not in this stage. That will only frighten people away I'm
> afraid. The main concerns now are "why the complexities?". People at
> this time perhaps won't bother looking into any lengthy documents at
> all.
>

For the moment ok if you think we are in a not-ready-for-mainline yet. 
But for the final version the documentation would be welcome, maybe with 
the pdf as reference. The documentation is always the last thing but 
it's important! :)

Marco
