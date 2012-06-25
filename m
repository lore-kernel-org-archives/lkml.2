Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2FYUEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:04:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab2FYUEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:04:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
References: <4FDEC3C2.4060909@secunet.com>
	<20120625113457.GA1289@amd.home.annexia.org>
	<x49r4t3z6s4.fsf@segfault.boston.devel.redhat.com>
	<20120625193218.GZ21859@amd.home.annexia.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 25 Jun 2012 16:04:32 -0400
In-Reply-To: <20120625193218.GZ21859@amd.home.annexia.org> (Richard
	W. M. Jones's message of "Mon, 25 Jun 2012 20:32:18 +0100")
Message-ID: <x49bok7yx7z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Richard W.M. Jones" <rjones@redhat.com> writes:

> On Mon, Jun 25, 2012 at 12:38:03PM -0400, Jeff Moyer wrote:
>> Please try the attached patch instead.  The patch I had originally
>> posted for this allowed marking the first buffer beyond EOD as
>> uptodate.  This isn't correct.  The patch I've attached below fixes the
>> infinite loop in __getblk_slow.
>
> This patch appears to fix both problems, thanks.

Thanks for testing, Rich!

-Jeff
