Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab2LJR7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:59:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab2LJR7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:59:37 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: JBottomley@parallels.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [patch,v3,repost 00/10] make I/O path allocations more numa-friendly
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 10 Dec 2012 12:59:30 -0500
In-Reply-To: <1354034799-8460-1-git-send-email-jmoyer@redhat.com> (Jeff
	Moyer's message of "Tue, 27 Nov 2012 11:46:28 -0500")
Message-ID: <x49zk1l6b5p.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi,
>
> This patch set makes memory allocations for data structures used in
> the I/O path more numa friendly by allocating them from the same numa
> node as the storage device.  I've only converted a handful of drivers
> at this point.  My testing is limited by the hardware I have on hand.
> Using these patches, I was able to max out the bandwidth of the storage
> controller when issuing I/O from any node on my 4 node system.  Without
> the patch, I/O from nodes remote to the storage device would suffer a
> penalty ranging from 6-12%.  Given my relatively low-end setup[1], I
> wouldn't be surprised if others could show a more significant performance
> advantage.
>
> This is a repost of the last posting.  The only changes are additional
> reviewed-by/acked-by tags.  I think this version is ready for inclusion.
> James, would you mind taking a look?

James?  Do you have any objections to including this for 3.8?

-Jeff
