Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152Ab2CFTKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:10:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133Ab2CFTKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:10:45 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: the maxcpus= boot parameter broke somewhere along the line
References: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com>
	<CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com>
	<20120306164835.GA26094@elliptictech.com>
	<CA+1xoqfzCb5X8wwvR1Bz+D6K20n7v3ChUR0E4Jqw_BWam5C7TQ@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 06 Mar 2012 13:08:04 -0500
In-Reply-To: <CA+1xoqfzCb5X8wwvR1Bz+D6K20n7v3ChUR0E4Jqw_BWam5C7TQ@mail.gmail.com>
	(Sasha Levin's message of "Tue, 6 Mar 2012 19:15:19 +0200")
Message-ID: <x49mx7thabf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> I can't reproduce it locally with a 3.3-rc5 kernel.

First, thanks for looking into it.  I just did a git pull, up to -rc6,
and the problem still persists on my machine.

Again, let me know if there's anything else I can provide that would be
helpful for debugging this.

Cheers,
Jeff
