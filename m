Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2LSTiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:38:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47177 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2LSThy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:37:54 -0500
Message-ID: <50D2178D.20900@kernel.dk>
Date: Wed, 19 Dec 2012 20:37:49 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] Bug-fixes to xen-blkfront for v3.8
References: <20121218051547.GA13450@phenom.dumpdata.com>
In-Reply-To: <20121218051547.GA13450@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-18 06:15, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8
> 
> which has a bug-fix to the xen-blkfront and xen-blkback driver
> when using the persistent mode. An issue was discovered where LVM
> disks could not be read correctly and this fixes it. There
> is also a change in llist.h which has been blessed by akpm.

Pulled for 3.8, thanks.

-- 
Jens Axboe

