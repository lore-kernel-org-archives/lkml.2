Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab0KOTJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:09:06 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46186 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab0KOTJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:09:03 -0500
Date: Mon, 15 Nov 2010 12:09:02 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: ltuikov@yahoo.com, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, jens.axboe@oracle.com,
        James.Bottomley@suse.de
Subject: Re: SCSI TMF processing; tag allocation
Message-ID: <20101115190901.GB6178@parisc-linux.org>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com> <4CE181A8.8050102@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE181A8.8050102@interlog.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 01:53:28PM -0500, Douglas Gilbert wrote:
> On the subject of UAS, due to some USB-3 streaming protocol
> requirements, three tag values cannot be used by SCSI. They
> are 0h, FFFEh and FFFFh. So those available for SCSI tag
> use are 1h to FFFDh inclusive.

I add 1 to the tag value handed to me by the block layer, and use that
as the tag value that I tell the UAS device this command has.  So if I
ask for 256 tags, I'll hand values 1-257 to the device.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
