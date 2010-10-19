Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832Ab0JSK1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:27:38 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:35677 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab0JSK1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:27:36 -0400
/m: 
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Oct 2010 12:27:26 +0200
From: Richard Weinberger <richard@nod.at>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <jdike@addtoit.com>, <user-mode-linux-devel@lists.sourceforge.net>,
        <viro@zeniv.linux.org.uk>, <toralf.foerster@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/1] hostfs: fix UML crash
In-Reply-To: <20101019011125.GA3905@lst.de>
References: <1287419814-20086-1-git-send-email-richard@nod.at>
 <20101018114039.503233da.akpm@linux-foundation.org>
 <201010182053.58496.richard@nod.at>
 <20101018130208.7b552527.akpm@linux-foundation.org>
 <20101019011125.GA3905@lst.de>
Message-ID: <0ec4162fd4bfc651204532a22ac87a79@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 03:11:25 +0200, Christoph Hellwig <hch@lst.de>
wrote:
> On Mon, Oct 18, 2010 at 01:02:08PM -0700, Andrew Morton wrote:
>> > >
>> > > Is there any reason for hostfs to be playing with the f_spare field at all?
> 
> No, there is no reason at all.  do_statfs is only called by
> hostfs_statfs, which is the hostfs implementation of ->statfs.  zeroing
> of the spare fields is done by common code (vfs_statfs_native).

Thanks!

> Can you submit a patch to just remove the spare_out argument to do_statfs?

Sure.
