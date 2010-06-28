Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0F1SmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:42:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0F1Sl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:41:58 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cfq: always return false from should_idle if slice_idle is set to zero
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>
	<1277149789-4493-2-git-send-email-jmoyer@redhat.com>
	<4C1FC4CA.7030007@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 28 Jun 2010 14:41:55 -0400
In-Reply-To: <4C1FC4CA.7030007@kernel.dk> (Jens Axboe's message of "Mon, 21
	Jun 2010 22:00:10 +0200")
Message-ID: <x49hbkndmoc.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 21/06/10 21.49, Jeff Moyer wrote:
>> Hi,
>> 
>> In testing a competing fsync-ing process and a sequential reader on
>> mid-grade storage, I found that cfq was incapable of achieving the I/O
>> rates of deadline, no matter how it was tuned.  Investigation, and insight
>> from Vivek (mostly the latter), led to identifying that we were still
>> idling for the last queue in the service tree.
>> 
>> Modifying cfq_should_idle to not idle when slice_idle is set to zero got
>> us much closer to the performance of deadline for this workload.  I have
>> one follow-on patch that gets us on-par with deadline, but I think this
>> patch stands alone.
>> 
>> Comments, as always, are appreciated.
>
> This looks good.

So.... applied to which branch?

Thanks!
Jeff
