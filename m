Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0HQNvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab0HQNvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:51:14 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 5/5] cfq-iosched: Documentation help for new tunables
References: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
	<1281566667-7821-6-git-send-email-vgoyal@redhat.com>
	<x494oeufkm2.fsf@segfault.boston.devel.redhat.com>
	<20100817125005.GB3495@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 17 Aug 2010 09:51:11 -0400
In-Reply-To: <20100817125005.GB3495@redhat.com> (Vivek Goyal's message of
	"Tue, 17 Aug 2010 08:50:05 -0400")
Message-ID: <x49y6c5tkj4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

>> I'm not sure we need documentation of this tunable twice.  Why not just
>> give guidance on when it should be set to 0 in the next section
>> (group_idle) and refer to cfq-iosched.txt?
>
> I have put one line saying for more details look at cfq-iosched.txt. I
> have still retained the slice_idle entry because at the end of the day
> this is the tunable I expect people to modify and not group_idle. Also
> notice that these are two different files (cfq-iosched.txt and
> blkio-controller.txt).

Yeah, I know it's in two places, and that means updating two places with
changes.  However, I doubt we'll have to update this often, so I'm not
going to argue.

Acked-by: Jeff Moyer <jmoyer@redhat.com>

Cheers,
Jeff
