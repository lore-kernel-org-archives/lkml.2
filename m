Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0JNPo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:44:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64074 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0JNPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:44:58 -0400
Message-ID: <4CB72547.7080001@oracle.com>
Date: Thu, 14 Oct 2010 08:44:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: xfs-masters@oss.sgi.com, lkml <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [xfs-masters] [PATCH -next] xfs: eliminate kconfig dependency
 warning
References: <20101013210142.9d524535.randy.dunlap@oracle.com> <20101014092503.GA28446@lst.de>
In-Reply-To: <20101014092503.GA28446@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/10 02:25, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 09:01:42PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix kconfig dependency warning to satisfy dependencies:
>>
>> warning: (XFS_FS && BLOCK || NFSD && NETWORK_FILESYSTEMS && INET && FILE_LOCKING && BKL) selects EXPORTFS which has unmet direct dependencies (NETWORK_FILESYSTEMS)
> 
> I'm not entirely sure what this gibberish means, but I'm pretty sure it
> does not make sense.
> 
> EXPORTFS is a small module that doesn't have any dependencie, and it's
> needed by XFS for the by-handle operation, and by nfsd for the same
> thing.  It has absolutely nothing to do with networking or network
> filesystems (as in network filesystem clients).
> 

Thanks, Dave and Christoph.  I'll look elsewhere for the glitch.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
