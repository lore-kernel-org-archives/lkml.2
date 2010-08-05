Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab0HETG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:06:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47208 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0HETGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:06:53 -0400
Date: Thu, 5 Aug 2010 15:01:38 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, Valdis.Kletnieks@vt.edu,
        josef@redhat.com,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: direct-io regression [Was: How to track down abysmal
 performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805190138.GV29846@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Valdis.Kletnieks@vt.edu, josef@redhat.com,
	Michael Monnerie <michael.monnerie@is.it-management.at>,
	Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <20100804085039.GA11671@infradead.org>
 <20100804091317.GA27779@isilmar-3.linta.de>
 <20100804092122.GA2998@infradead.org>
 <20100804073546.GA7494@comet.dominikbrodowski.net>
 <201008041116.09822@zmi.at>
 <20100804102526.GB13766@isilmar-3.linta.de>
 <15446.1280953986@localhost>
 <20100805093100.GA3001@comet.dominikbrodowski.net>
 <20100805113240.GA29846@think>
 <x49tyn8c2ea.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49tyn8c2ea.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C5B0BB1.01E8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 02:58:37PM -0400, Jeff Moyer wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> 
> > But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> > seems a little high.  
> 
> I'm not sure why you think that.  We're talking about a plain old SATA
> disk, right?  I can get 40-50MB/s on my systems for 8KB O_DIRECT reads.
> What am I missing?

Clearly I'm wrong, his drive is going much faster ;)  I expect the
smaller reads to be slower but the drive's internal cache is doing well.

-chris

