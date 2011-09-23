Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1IWPSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:18:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57650 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754555Ab1IWPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:18:42 -0400
Date: Fri, 23 Sep 2011 11:18:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rocko Requin <rockorequin@hotmail.com>
cc: hare@suse.de, <j-nomura@ce.jp.nec.com>, <ben@decadent.org.uk>,
        <jaxboe@fusionio.com>, <james.bottomley@hansenpartnership.com>,
        <tytso@mit.edu>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: RE: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
In-Reply-To: <BAY151-W13DDCCEFEB7B68EE506214A10C0@phx.gbl>
Message-ID: <Pine.LNX.4.44L0.1109231114460.2059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011, Rocko Requin wrote:

> > Rocko:
> > 
> > Can you try testing this patch instead of all the patches I sent to 
> > you (but keep Ted's patch)?
> > 
> > Alan Stern
> > 
> 
> The simpler patch (in conjunction with Ted's patch) does stop the
> crashes. I get the same results as before: no kernel crashes
> (marvellous!), but the script's attempt to umount fails. I can then
> manually umount afterwards.

That sounds like a problem in the ext4 unmount implementation.  Ted
should be able to help track it down.

What happens if you change your script to try two unmounts in a row?  
In theory, the second should work like your manual unmount.

> Are these patches likely to be backported to the 3.0 kernel?

Yes, I should think so.  The ext4/ext3 patches may be ported even
farther back.

Alan Stern

