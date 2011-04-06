Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab1DFVhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:37:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61849 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab1DFVhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vfpA1jI14mVZhQ6dCxcsOVBnAWVXqzFGWDiqvBJSq6JUfHHsiQEsDwpQ0KnHjPRkf5
         jzc2pdAuWITmSNSgOFvAX2QpBGiqoRf/Ti3eD9FMmOX1A/8RVX1yLwzsp/2faJdVhtf3
         J2Oy8I0JLCgqqpiXGTWtJFcDNe7fXKV8ZqLPU=
Date: Wed, 6 Apr 2011 14:37:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110406213718.GA14139@mtj.dyndns.org>
References: <20110404211604.GB6133@sucs.org>
 <20110406130423.GE4142@mtj.dyndns.org>
 <20110406212611.GA5131@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406212611.GA5131@sucs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 10:26:11PM +0100, Sitsofe Wheeler wrote:
> On Wed, Apr 06, 2011 at 06:04:23AM -0700, Tejun Heo wrote:
> > I think disk_block_events was a bit too agressive with optimization.
> > Can you please test the following patch and see whether the problem
> > goes away?
> 
> With the 2.6.39-rc2 the warning has mysteriously disappeared all by
> itself. Could it be that other parts of the kernel were causing this to
> manifest itself?

The problem would be quite timing dependent.  It would be great if you
can prepare a setup where you can reproduce the problem on some
regular basis and make sure that the problem goes away with the patch
applied.

Thanks.

-- 
tejun
