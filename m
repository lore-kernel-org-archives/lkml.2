Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1GFIFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:05:10 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34652
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290Ab1GFIFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:05:08 -0400
Date: Wed, 6 Jul 2011 04:05:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, T?r?k Edwin <edwintorok@gmail.com>,
        xfs-masters@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS internal error (memory corruption)
Message-ID: <20110706080505.GA2354@infradead.org>
References: <4E12A927.9020102@gmail.com>
 <20110705130932.GF1026@dastard>
 <4E1313C1.6020309@gmail.com>
 <20110706040403.GW1026@dastard>
 <20110706070756.GA25800@infradead.org>
 <20110706072221.GZ1026@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706072221.GZ1026@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 05:22:21PM +1000, Dave Chinner wrote:
> Unless you have a good sized chunk of BBWC in front of your disks,
> in which case internal logs are just as fast. In fact, internal logs
> can are often faster in this case because an internal log on a 12
> disk RAID6 array can sink a whole log more bandwidth than an external
> log on a 2-disk RAID0 mirror.....
> 
> At least, that's what my hardware tells me. ;)

Sure, a nice BBWC setup will give you good results.  But it's generally
much more expensive than a simple setup with a raid5 or 6 and a mirror for
the log device.

