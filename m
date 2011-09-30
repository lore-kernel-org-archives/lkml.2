Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1I3Bzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:55:37 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34563 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1I3Bzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:55:36 -0400
Date: Thu, 29 Sep 2011 21:53:19 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: Andrew Morton <akpm00@gmail.com>
Cc: Greg KH <gregkh@suse.de>, stable-review@kernel.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-ID: <2d56b06c-a778-4cb7-a952-a4384c8ce3cc@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110929164117.8ffc3878.akpm00@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.3.113.99]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On Thu, 29 Sep 2011 19:31:41 -0400 (EDT)
> 
> (Please hit <enter> occasionally?)

It's this frikkin' Zimbra mail client.  Something about it using
text/flowed or something like that.  Anyway, I'll manually line
wrap.

> This is all waaaaay too confusing.  For starters, please never say
> "the
> patch" or "it" or "new patch".  Patches have names - let's use them,
> and greatly reduce the amount of head-spinning.  (And I mean "names",
> not git hashes, which can be different in different trees).
> 
> There are no patches againt ipc/mqueue.c pending in any tree I can
> see
> apart from the 4+fix from yourself, which are in -mm and will be in
> linux-next next time I send an update to Stephen:
> 
> ipc-mqueue-cleanup-definition-names-and-locations.patch
> ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
> ipc-mqueue-enforce-hard-limits.patch
> ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
> ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch
> 
> Everything else is already in Linus's tree.
> 
> I don't have a clue what's going on here.  Let's start again.

Your right.  The patch I was referring to was the patch I NAKed,
which is this patch:
d40dcdb ipc/mqueue.c: fix mq_open() return value

I didn't think it was in Linus' tree because of faulty memory.  I
remembered seeing ENOMEM as the return and not EMFILE when I wrote
my patches.  But, that makes sense given that I was originally staring
at our internal 2.6.18 kernel tree as I wrote the code, and only
later did I port it to Linus' tree.  I spent a lot more time looking
at our internal tree where the above patch doesn't exist.

So, as I said, Greg I withdraw my NAK and we'll just fix it up in
your stable tree after my patches have been reviewed/accepted in
some version of Linus' tree.

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

