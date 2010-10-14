Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0JNTfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:35:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab0JNTfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:35:39 -0400
Subject: Process to push changes to include/linux/types.h
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, agruen@suse.de,
        jengelh@medozas.de, davem@davemloft.net, andi@firstfloor.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 15:34:52 -0400
Message-ID: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch was posted a bit ago by agruen which made a change to
include/linux/types.h changing aligned_u64 to __aligned_u64 and exposing
this new type to userspace.

http://marc.info/?l=linux-kernel&m=128316627912457&w=2

Everyone seemed to agree the patch was a good idea and was correct.  At
the moment this change only really affects network code, but I would
very much like to make use of this change in the notification tree.
Dave Miller did not apply the patch because "Someone has to first add
the types to linux/types.h, and that doesn't go through my tree."

http://marc.info/?l=linux-kernel&m=128634544524035&w=2

I'm a little stuck as to the right path forward.  I normally would have
had no qualms about adding __aligned_u64 to types.h in the notification
tree and pushing it to Linus next go-round and then the net tree could
convert and potentially drop the old aligned_u64 type (but again that
would be outside the net tree).  Since Dave isn't willing to add the
type and I don't want to get called too many bad names, I figured I
should try to find if there is some better way, maintainer, or tree who
should be adding this new type.

Who needs to sign off on a new type in types.h?  Who should add it?
Should I just ram it on in there myself, take any flames that come
along, and then let net finish their cleanups after I've been charred?
Any suggestions on the best course of action would be appreciated.

-Eric

