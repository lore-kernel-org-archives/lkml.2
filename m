Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0HKPlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:41:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab0HKPlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:41:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: cfq: oops in __call_for_each_cic
References: <20100810064045.6996f3b7@tlielax.poochiereds.net>
	<x49zkwu8s3y.fsf@segfault.boston.devel.redhat.com>
	<20100810102718.45bddc9d@tlielax.poochiereds.net>
	<4C6179DD.7010000@kernel.dk>
	<20100810123525.3112a382@tlielax.poochiereds.net>
	<4C61E7B1.1090607@kernel.dk>
	<20100810212331.197026dc@corrin.poochiereds.net>
	<4C62A44D.3010102@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 11 Aug 2010 11:41:09 -0400
In-Reply-To: <4C62A44D.3010102@kernel.dk> (Jens Axboe's message of "Wed, 11
	Aug 2010 09:23:25 -0400")
Message-ID: <x49fwylb1ii.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>> #period in days   delay in minutes   job-identifier   command
>> 1	5	cron.daily		nice run-parts /etc/cron.daily
>> 7	25	cron.weekly		nice run-parts /etc/cron.weekly
>> @monthly 45	cron.monthly		nice run-parts /etc/cron.monthly
>
> ionice must be a deciding factor in this, perhaps coupled with something
> else. Otherwise we would be seeing a lot more of these.

Well, what's really strange is that this is only affecting f14.  I'm
installing a system and I'll see if I can't reproduce it.

Cheers,
Jeff
