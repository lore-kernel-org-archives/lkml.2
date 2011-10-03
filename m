Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1JCTcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:32:45 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60374 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756250Ab1JCTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:32:40 -0400
Subject: Re: Re: BUG in kernel: Wrong Handling of USB
 =?UTF-8?Q?HDD=E2=80=99s?= in scsiglue(slave_configure) and
 scsi/sd(sd_read_cache_type)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.1110031408420.1882-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1110031408420.1882-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 14:32:35 -0500
Message-ID: <1317670355.3041.53.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 14:10 -0400, Alan Stern wrote:
> > No. You need to also take into account the RBC
> > device parameters mode page if present. See above.
> 
> All right, suppose neither page is present.  Does it then make sense to 
> assume by default that write caching is enabled?

You're the USB expert ... if we do that, we'll start sending
SYNCHRONIZE_CACHE commands down to a whole slew of devices we didn't
before ... is that going to cause problems with any USB SATLs?

James


