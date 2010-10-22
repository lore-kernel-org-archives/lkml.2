Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0JVI5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:57:25 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45286 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0JVI5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:57:24 -0400
Message-ID: <4CC15204.90206@kernel.dk>
Date: Fri, 22 Oct 2010 10:57:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: linux-next regression: IO errors in with ext4 and xen-blkfront
References: <4CBF83A0.8090802@goop.org> <4CBF84C9.6050606@goop.org> <4CC148E5.2030605@kernel.dk> <20101022082916.GA14070@infradead.org> <4CC1515E.6080006@kernel.dk> <20101022085624.GA5672@infradead.org>
In-Reply-To: <20101022085624.GA5672@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-22 10:56, Christoph Hellwig wrote:
> On Fri, Oct 22, 2010 at 10:54:54AM +0200, Jens Axboe wrote:
>> So how about we just disable barriers for Xen atm? I would really really
>> like to push that branch out as well now, since I'll be travelling for
>> most of the merge window this time.
> 
> Yes, that's what removing/commenting out that line does.

Certainly, but I meant in the barrier branch for submission. If
it doesn't do empty flushes to begin with, that should be fixed
up before being enabled in any case.

I'll disable barrier support in xen-blkfront.c for now.

-- 
Jens Axboe

