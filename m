Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2IUORo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:17:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab2IUORm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:17:42 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jagdish Motwani <jagdish.motwani@elitecore.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: performance degradation on kernel upgrade (due to commit ab0a9735e06914ce4d2a94ffa41497dbc142fe7f )
References: <505C700C.3010403@elitecore.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 21 Sep 2012 10:17:37 -0400
In-Reply-To: <505C700C.3010403@elitecore.com> (Jagdish Motwani's message of
	"Fri, 21 Sep 2012 19:17:56 +0530")
Message-ID: <x49r4pvlata.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jagdish Motwani <jagdish.motwani@elitecore.com> writes:

> Recently i upgraded my kernel from 2.6.29.6 to 2.6.35.14.
>
> After upgrading i got very poor performance on my postgre database.
[...]
> Using git bisect, i got commit ab0a9735e06914ce4d2a94ffa41497dbc142fe7f
>
> Is it a behavior change or am i missing something? Are there any
> workarounds for this?

commit ab0a9735e06914ce4d2a94ffa41497dbc142fe7f
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Oct 29 14:14:04 2009 +0100

    blkdev: flush disk cache on ->fsync

This is a data integrity fix, and you really don't want to work around
it.

Cheers,
Jeff
