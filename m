Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1JCOoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:44:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab1JCOoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:44:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christophe Saout <christophe@saout.de>,
        device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [dm-devel] Block regression since 3.1-rc3
References: <1317397918.27140.15.camel@localhost>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 03 Oct 2011 10:43:52 -0400
In-Reply-To: <1317397918.27140.15.camel@localhost> (Christophe Saout's message
	of "Fri, 30 Sep 2011 17:51:57 +0200")
Message-ID: <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Saout <christophe@saout.de> writes:

> I think you guys should know - maybe you have an idea or have something
> for me to test.  I would have tried to file a bug somewhere, but half of
> the infrastructure is down at the moment.

You didn't include the top few lines which tell us what went wrong.  I
tried to reproduce this myself, but I ran into other issues with GFS2.
Anyway, it would help a great deal if you could retrigger the failure
and provide the full failure output.  You can get that by issuing the
'dmesg' command and redirecting it to a file.  And please CC me on any
future correspondences on this issue.

Thanks!
Jeff
