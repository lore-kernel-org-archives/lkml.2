Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab1I2XlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:41:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57833 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab1I2XlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:41:19 -0400
Date: Thu, 29 Sep 2011 16:41:17 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Doug Ledford <dledford@redhat.com>
Cc: Greg KH <gregkh@suse.de>, stable-review@kernel.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-Id: <20110929164117.8ffc3878.akpm00@gmail.com>
In-Reply-To: <d089f3ec-ccfc-4350-bd11-b8ccadf4ad3a@zmail05.collab.prod.int.phx2.redhat.com>
References: <20110929190855.GA5381@suse.de>
	<d089f3ec-ccfc-4350-bd11-b8ccadf4ad3a@zmail05.collab.prod.int.phx2.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 19:31:41 -0400 (EDT)
Doug Ledford <dledford@redhat.com> wrote:

> ----- Original Message -----
> > Sorry, I ment Linus's tree, that's where it matters for the stable
> > releases.
> 
> The patch in question hasn't hit Linus' tree yet, but it's queued up in Stephen Rothwell's for-next tree.  As I understand it, Andrew's tree gets fed into that on a somewhat regular basis, and Andrew took my four patches (plus a patchcheck fixup he committed) already.  So, I pulled Stephen's for-next, put my patches plus the patchcheck fix on top, then wrote a fixup patch that fixes what I saw as being wrong in the patch in question.

(Please hit <enter> occasionally?)

This is all waaaaay too confusing.  For starters, please never say "the
patch" or "it" or "new patch".  Patches have names - let's use them,
and greatly reduce the amount of head-spinning.  (And I mean "names",
not git hashes, which can be different in different trees).

There are no patches againt ipc/mqueue.c pending in any tree I can see
apart from the 4+fix from yourself, which are in -mm and will be in
linux-next next time I send an update to Stephen:

ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch

Everything else is already in Linus's tree.

I don't have a clue what's going on here.  Let's start again.


