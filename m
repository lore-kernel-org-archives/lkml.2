Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1GOTSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 15:18:35 -0400
Received: from natasha.panasas.com ([67.152.220.90]:56437 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1GOTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 15:18:34 -0400
X-Greylist: delayed 2758 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jul 2011 15:18:34 EDT
Message-ID: <4E208302.9020908@panasas.com>
Date: Fri, 15 Jul 2011 11:12:18 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Benny Halevy <bhalevy@panasas.com>, <osd-dev@open-osd.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
References: <4E1D6900.6040500@cam.ac.uk> <20110713144119.6e28dc03@stein>
In-Reply-To: <20110713144119.6e28dc03@stein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 05:41 AM, Stefan Richter wrote:
> On Jul 13 Jonathan Cameron wrote at LKML:
> [...]
>> Taking ida's first, how about the following patch?  I'm not at
>> all attached to the form it takes, merely to cutting out on the
>> cut and paste.
>>
>> Note I've done only a few random places.  There aren't that many ida
>> users and I've only played with that for now.
>>
>> Remaining ida cases:
>>
>> drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c:  (cleans up in case of out of range)
>> drivers/scsi/osd/osd_uld.c: (locks not taken)
> [...]
> 
> Boaz, Benny,
> 
> osd_uld.c::osd_minor_ida is accessed unsafely.
> Device probe() and remove() methods are not globally serialized.

Sorry for the delay. Vacation

Thanks Stefan I'll look into it. I remember I thought about
it and tested it at the time, but I might be wrong. I'll look
into it.

Thanks
Boaz
