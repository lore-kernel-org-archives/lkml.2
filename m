Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1LHMaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:30:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab1LHMap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:30:45 -0500
Date: Thu, 8 Dec 2011 13:30:38 +0100
From: Karel Zak <kzak@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20111208123038.GA16493@nb.redhat.com>
References: <cover.1322709471.git.psusi@cfl.rr.com> <4ED6F320.5060709@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED6F320.5060709@cfl.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 10:23:12PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Add a new operation code ( BLKPG_RES_PARTITION ) to the
> BLKPG ioctl that allows altering the size of an existing
> partition, even if it is currently in use.

 It seems very close to Vivek's BLKPG_EXTEND_PARTITION idea, see:

    https://lkml.org/lkml/2011/9/1/351

 It's evident that we (userspace) need something better than
 BLKPG_{ADD,DEL}_* and BLKRRPART, but no response from kernel side :-(

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
