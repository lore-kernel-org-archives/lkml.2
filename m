Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab2CFALs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 19:11:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:45417 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054Ab2CFALq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 19:11:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125382482"
Date: Mon, 5 Mar 2012 16:11:46 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "linux-fsdevel@vger.kernel.o..." <linux-fsdevel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [BUG] scsi_device.device == NULL in sd_revalidate_disk()
Message-ID: <20120306001146.GA31227@localhost>
References: <20120305234133.GA13690@localhost>
 <CA+5PVA4axkm-S5-E1pnkgNpDLy3DHegFL2Cfo2i-8HOsfGMHDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA4axkm-S5-E1pnkgNpDLy3DHegFL2Cfo2i-8HOsfGMHDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 07:02:08PM -0500, Josh Boyer wrote:
> On Mon, Mar 5, 2012 at 6:41 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Hi,
> >
> > I ran into a NULL dereference bug on USB key hot remove, which should
> > be caused by the below skdp->device reference
> >
> >        static int sd_revalidate_disk(struct gendisk *disk)
> >        {
> >                struct scsi_disk *sdkp = scsi_disk(disk);
> > ==>             struct scsi_device *sdp = sdkp->device;
> 
> This has been reported numerous times.  There are patches to the block layer
> that are supposed to fix it, but they haven't hit Linus' tree yet.  I think
> we're waiting on Jens to push them.

OK, thanks for the information!

Thanks,
Fengguang
