Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab1JNQ7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:59:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37727 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab1JNQ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:59:36 -0400
Date: Fri, 14 Oct 2011 12:59:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: lidongyang@novell.com, joe.jin@oracle.com, Ian.Campbell@citrix.com,
        lersek@redhat.com, jbeulich@suse.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.2 - blkback and blkfront
 patches for 3.2
Message-ID: <20111014165915.GA10538@phenom.oracle.com>
References: <20111013152157.GA9627@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013152157.GA9627@phenom.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090203.4E986A70.0040,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>       xen/blkback: Fix the inhibition to map pages when discarding sector ranges.

And I accidently messed that up. I put in a patch that had == instead of !=.

So on top of these patches I've also stuck this in the git tree:

git 53289f32632cca41c81b71b928f3d126c5564342
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Fri Oct 14 12:13:05 2011 -0400

    xen/blkback: Check for proper operation.
    
    The patch titled: "xen/blkback: Fix the inhibition to map pages
    when discarding sector ranges." had the right idea except that
    it used the wrong comparison operator. It had == instead of !=.
    
    This fixes the bug where all operations would have been stalled.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>



Please make sure you have that when you pull.

Thanks!
