Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0JXGTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 02:19:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:36166 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab0JXGTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 02:19:08 -0400
Date: Sun, 24 Oct 2010 08:19:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
In-Reply-To: <AANLkTikc74bA+OPJjhLUHu_mp59L=SKnPTXjPK=E28U5@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1010240816140.6879@pobox.suse.cz>
References: <alpine.LNX.2.00.1010232314400.6879@pobox.suse.cz> <AANLkTikc74bA+OPJjhLUHu_mp59L=SKnPTXjPK=E28U5@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Jarod Wilson wrote:

> > please pull from 'for-linus' branch at
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
> >
> > to receive the HID subsystem patches below. Mostly adding support for a
> > few new multitouch toys, and improving already existing drivers. Plus some
> > bugfixes which were not urgent enough for .36.
> 
> *cough*
> 
> https://patchwork.kernel.org/patch/161481/
> 
> What's a guy gotta do to get that patch merged too? :)

Bah, it's still pending in my TODO folder, sorry for that. I am not really 
convinced whether it's the right aproach.

First, I'll go check HUT how much non-standard the usages you are adding 
to generic code, are. Perhaps it would satisfy separate driver on the hid 
bus?
(Second, I hope to shovel all the 'drivers' which only do specialized 
mappings into userspace/udev actually).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
