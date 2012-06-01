Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2FANLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018Ab2FANLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:11:48 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 05/11] mtip32xx: Set block queue boundary variables
References: <4FC57B1B.5010901@micron.com> <4FC7130B.6040506@kernel.dk>
	<4FC794BD.1000309@micron.com>
	<x49sjegb7h4.fsf@segfault.boston.devel.redhat.com>
	<4FC7B491.9030105@micron.com>
	<x49hauwb3e1.fsf@segfault.boston.devel.redhat.com>
	<4FC85AC9.8010707@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 01 Jun 2012 09:11:37 -0400
In-Reply-To: <4FC85AC9.8010707@kernel.dk> (Jens Axboe's message of "Fri, 01
	Jun 2012 08:01:45 +0200")
Message-ID: <x49d35jyy5y.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>> Jens, I actually think changing nr_requests makes sense;  the only
>> question in my mind is where to do it.  (There's no point in artificially
>> limiting the device by default.)  IIRC, your general rule was to set this
>> value to 2x the device's queue depth.  So, given that this driver
>> doesn't use the blk-tag interfaces, what do you think would be the
>> cleanest way to bump nr_requests in this (and the more general) case?
>
> But it doesn't matter for this case, the driver isn't consuming request
> structures, hence the value set doesn't make any difference. So the only
> limiter of queue depth is the driver itself.

Good point.  Nevermind.  ;-)

Cheers,
Jeff
