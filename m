Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab2JCPFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:05:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442Ab2JCPFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:05:48 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: Limit the number of requests in the bio list
References: <1348767205-17230-1-git-send-email-lczerner@redhat.com>
	<x49ipaukud8.fsf@segfault.boston.devel.redhat.com>
	<alpine.LFD.2.00.1210021042580.21903@localhost>
	<20121002195934.GA2657@devil.redhat.com>
	<x49txubvd9d.fsf@segfault.boston.devel.redhat.com>
	<alpine.LFD.2.00.1210031659480.18540@localhost>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 03 Oct 2012 11:05:44 -0400
In-Reply-To: <alpine.LFD.2.00.1210031659480.18540@localhost>
 (=?utf-8?B?Ikx1a8OhxaE=?=
	Czerner"'s message of "Wed, 3 Oct 2012 17:01:17 +0200 (CEST)")
Message-ID: <x49haqbvbnb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukáš Czerner <lczerner@redhat.com> writes:

>> Did you look at system time?
>> 
>> -Jeff
>
> Hi, none of the times showed any significant difference, there was
> not any pattern suggesting a problem. Also the system time is included
> in the real time, so it would show anyway I guess.

Only if you're cpu bound.  If you aren't, elevated system time may not
increase overall runtime.

Cheers,
Jeff
