Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab1LHMfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:35:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1LHMfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:35:39 -0500
Date: Thu, 8 Dec 2011 13:35:34 +0100
From: Karel Zak <kzak@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add BLKPG_GET_PARTITION operation
Message-ID: <20111208123534.GB16493@nb.redhat.com>
References: <cover.1322709471.git.psusi@cfl.rr.com> <4ED6F340.9050000@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED6F340.9050000@cfl.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 10:23:44PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Add a new operation to the BLKPG ioctl to read the partition.
> This allows user space to find the current start and length
> of a partition without having to open the partition and use
> the long depreciated HDIO_GETGEO ioctl.

 $ cat /sys/block/sda/sda1/{size,start}
 4096000
 2048

 ...is probably the best way if you want to avoid problems with
 permissions and deprecated (or all) ioctls :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
