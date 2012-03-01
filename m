Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2CAUdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:33:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757685Ab2CAUdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:33:18 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/22] loop: Issue O_DIRECT aio with pages
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
	<20120228092926.GA2766@infradead.org> <4F4CEF5A.1020207@zabbo.net>
	<20120229090803.GA9995@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 01 Mar 2012 15:33:11 -0500
In-Reply-To: <20120229090803.GA9995@infradead.org> (Christoph Hellwig's
	message of "Wed, 29 Feb 2012 04:08:03 -0500")
Message-ID: <x49obsgawoo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Feb 28, 2012 at 10:14:34AM -0500, Zach Brown wrote:
>> Yeah, that's reasonable.  Perhaps obviously, we started with new entry
>> points to minimize the amount of churn we'd have to go through to test
>> the change in behaviour.
>> 
>> It's going to be messy to try and abstract away the pinning and dirtying
>> of the iter regions from direct IO through the iter interface, but maybe
>> not horribly so.
>
> I don't really care to much about the implementation inside fs/direct-io.c
> (at least for now - once I see it I might still scream "bloody
> murder!").
>
> The point is to pass the iov_iter all the way down to a common entry
> point in fs/direct-io.c, so that the filesystems don't have to care
> for that difference.

I started reviewing, but I think I'll hold off until the next posting.
Dave, what was the original subject of the thread from Zach back in '09?
That spinics link isn't working for me anymore, and I'd like to go back
over my review comments from back then.

Cheers,
Jeff
