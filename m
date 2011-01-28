Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1A1A74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 19:59:56 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:39738 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752306Ab1A1A74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 19:59:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAGajQU1Ld/sX/2dsb2JhbAAMhAiqB6M1kF6BI4M4dASFFw
X-IronPort-AV: E=Sophos;i="4.60,388,1291611600"; 
   d="scan'208";a="89492284"
Message-ID: <4D421507.1030006@teksavvy.com>
Date: Thu, 27 Jan 2011 19:59:51 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Stan Hoeppner <stan@hardwarefreak.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com> <20110127234152.GN21311@dastard>
In-Reply-To: <20110127234152.GN21311@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-27 06:41 PM, Dave Chinner wrote:
> On Thu, Jan 27, 2011 at 10:12:23AM -0500, Mark Lord wrote:
..
>> Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
>> of this system? 
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

That entry says little beyond "blindly trust the defaults".
But thanks anyway (really).

> And perhaps you want to consider the allocsize mount option, though
> that shouldn't be necessary for 2.6.38+...

That's a good tip, thanks.
>From my earlier posting:

>   /dev/sdb1 on /var/lib/mythtv type xfs
> (rw,noatime,allocsize=64M,logbufs=8,largeio)

Maybe that allocsize value could be increased though.
Perhaps something on the order of 256MB might do it.

Thanks again!
