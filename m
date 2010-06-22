Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab0FVO15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab0FVO14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:27:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cfq: allow dispatching of both sync and async I/O together
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>
	<1277149789-4493-3-git-send-email-jmoyer@redhat.com>
	<4C1FC4B4.3060700@kernel.dk> <20100621232208.GA10175@redhat.com>
	<20100622040700.GA12502@redhat.com>
	<x49sk4ffd6l.fsf@segfault.boston.devel.redhat.com>
	<20100622131853.GB13153@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Jun 2010 10:27:52 -0400
In-Reply-To: <20100622131853.GB13153@redhat.com> (Vivek Goyal's message of
	"Tue, 22 Jun 2010 09:18:53 -0400")
Message-ID: <x49k4prf8gn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Jun 22, 2010 at 08:45:54AM -0400, Jeff Moyer wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > On Mon, Jun 21, 2010 at 07:22:08PM -0400, Vivek Goyal wrote:
>> > So looks like firefox launching times have not changed much in the presence
>> > of heavy buffered writting going on root disk. I will do more testing tomorrow.
>> 
>> Was the buffered writer actually hitting disk?  How much memory is on
>> your system?
>
> I have 4G of memory in the system. I used to wait for 10-15 seconds after
> writer has started and then launch firefox to make sure writes are actually
> hitting the disk.
>
> Are you seeing different results in your testing?

No, I hadn't got to testing this yet.  I was just making sure the test
procedure was sane (and it is).  Thanks for doing the testing!

-Jeff
