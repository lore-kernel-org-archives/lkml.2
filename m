Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab1DQHhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 03:37:48 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45825 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1DQHhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 03:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pMe77pv1xe19HX40yLULm3VbUE0dyU6BS2auFoiXoORRe1a7UtyHIje/iT7NJn2BBE
         Hbn6RJPzwRI27YvDd3/PuI+L8np9Lbl0B1asCc1brHid2B0/nIUD3xj6XiP9I3R+btvB
         28DYMUjkULxeLq98h3b2OrM5vlPz4gvJB1uis=
Message-ID: <4DAA976A.3080007@gmail.com>
Date: Sun, 17 Apr 2011 09:31:54 +0200
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
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] IO-less dirty throttling v7
References: <20110416132546.765212221@intel.com>
In-Reply-To: <20110416132546.765212221@intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/04/2011 15:25, Wu Fengguang ha scritto:
> Andrew,
>
> This revision undergoes a number of simplifications, cleanups and fixes.
> Independent patches are separated out. The core patches (07, 08) now have
> easier to understand changelog. Detailed rationals can be found in patch 08.
>
> In response to the complexity complaints, an introduction document is
> written explaining the rationals, algorithm and visual case studies:
>
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/slides/smooth-dirty-throttling.pdf

It'd be great if you wrote a summary in the kernel documentation.

Marco
