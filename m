Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab1JDNdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:33:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab1JDNc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:32:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christophe Saout <christophe@saout.de>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [dm-devel] Block regression since 3.1-rc3
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 04 Oct 2011 09:32:45 -0400
In-Reply-To: <1317729761.25998.4.camel@localhost> (Christophe Saout's message
	of "Tue, 04 Oct 2011 14:02:41 +0200")
Message-ID: <x49pqicnapu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Saout <christophe@saout.de> writes:

> Hi Jeff,
>
>> Anyway, it would help a great deal if you could retrigger the failure
>> and provide the full failure output.  You can get that by issuing the
>> 'dmesg' command and redirecting it to a file.
>
> Oh, sorry, yes, there's a line missing.
>
> Line 323 is this one: BUG_ON(!rq->bio || rq->bio != rq->biotail);
>
> The bug is not specific to GFS2, I also get it when using an ext3 mount
> on that multipath storage pool when writing to a file.

Great, thanks!  I tried ext3 and ext4 as well, and was unable to trigger
this problem.  I setup a linear volume on top of a multipath device.  Is
that the configuration you are using?  Anyway, this may be enough to get
me on the right path...

Cheers,
Jeff
