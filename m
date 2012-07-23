Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2GWUTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:19:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab2GWUTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:19:51 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, <amethyst623@163.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: mount stuck, khubd blocked
References: <Pine.LNX.4.44L0.1207231556070.1633-100000@iolanthe.rowland.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Jul 2012 16:19:36 -0400
In-Reply-To: <Pine.LNX.4.44L0.1207231556070.1633-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Mon, 23 Jul 2012 15:57:55 -0400 (EDT)")
Message-ID: <x49y5mas013.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Mon, 23 Jul 2012, Jeff Moyer wrote:
>
>> > Jeff, does this also fix Bugzilla #43269?
>> 
>> First, this patch is wrong.  I posted another version later on that got
>> merged for 3.5.
>> 
>> As for bug 43269, it does not look like the same symptoms, so I would
>> not expect the patches I posted to resolve that issue.  Sorry.
>
> Can you suggest someone who might be able to help with #43269?  It has 
> been languishing since May.

Well, either Jens or James may be able to make more progress faster than
I could.  I'm a little concerned that the reporter has unreasonable
expectations for his use of library calls, but I suppose that's a
separate issue.

James, Jens:
  https://bugzilla.kernel.org/show_bug.cgi?id=43269

Cheers,
Jeff
