Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab0FKS4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 14:56:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab0FKS4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 14:56:33 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Yedire\, Sandeep" <syedire@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK with Ext3
References: <AANLkTilXU8paNWNUSQIjcQ7xaaWgB1bEyd70d5P_nWf2@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 11 Jun 2010 14:56:30 -0400
In-Reply-To: <AANLkTilXU8paNWNUSQIjcQ7xaaWgB1bEyd70d5P_nWf2@mail.gmail.com>
	(Sandeep Yedire's message of "Wed, 9 Jun 2010 17:00:45 +0530")
Message-ID: <x498w6liejl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yedire, Sandeep" <syedire@gmail.com> writes:

> Hi ALL,
> I am currently using o_nonblock flag for writing a file of 64MB over a
> flash device. Flash is formatted with ext3 filesystem with default
> options.
> When instrumented the driver code for collecting the erase/write count
> at sector level. I noticed that o_nonblock has no effect on this
> count. There is no difference in erase/write count with o_nonblock
> flag or without this flag.
> When selected Ext2 as filesystem I noticed a significant difference in
> the erase/write count.
> There were more updates with o_nonblock and test application was
> faster. I could confirm this by checking the Dirty page limit in the
> background. It was updating faster in case of Ext2 not incase of Ext3.
>
> Can any one explain on o_nonblock flag in case of  Ext3 filesystem?

The O_NONBLOCK flag should be ignored when opening files on a file
system.  I'm not sure how to explain your observations.

What exactly were you trying to accomplish?

Cheers,
Jeff
