Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab0GVTQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:16:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35493 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab0GVTQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:16:38 -0400
Date: Thu, 22 Jul 2010 12:15:41 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Filesystem hints to storage
Message-ID: <20100722191541.GA12376@mail.oracle.com>
Mail-Followup-To: Matthew Wilcox <matthew@wil.cx>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100722180854.GB22009@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722180854.GB22009@parisc-linux.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C489914.0010:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 12:08:54PM -0600, Matthew Wilcox wrote:
> For Enterprise NVMHCI, the working group is looking at refining these
> hints.  Are there any hints that people would like to see added or
> removed from the list in NVMHCI 1.0?
> 
> I think there are some hints that are hard for the filesystem to know
> itself, never mind pass down, so it'd be good to remove them to reduce
> the complexity.  Contrariwise, there are some hints I think the filesystem
> could pass down that aren't in the spec today, such as the flags from
> madvise (random access vs sequential access) and whether the access is
> for fs metadata or application data.

	If we're looking at the filesystem interface to all of this, I
would think these hints could be used by non-SSD storage as well.
Not only would a storage array benefit from knowing about random vs
sequential access, but expected redundancy hints would be huge in
managing utilization.

Joel

-- 

Life's Little Instruction Book #396

	"Never give anyone a fruitcake."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
