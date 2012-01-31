Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2AaMli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:41:38 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33482 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2AaMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:41:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: sysfs regression: wrong link counts
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com>
	<20120130221059.26ab5edf@pyramind.ukuu.org.uk>
	<20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org>
	<4F27C6EB.2070305@suse.cz>
Date: Tue, 31 Jan 2012 04:44:11 -0800
In-Reply-To: <4F27C6EB.2070305@suse.cz> (Jiri Slaby's message of "Tue, 31 Jan
	2012 11:48:11 +0100")
Message-ID: <m14nvc82jo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/0KIQBZOEWMuTKVquZK1MWJ4aXgY7JP3E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> Oh, we are not going to break userspace with 3.3, are we? 

No.  This code is currently scheduled for 3.4.

> I understand
> that what sensors do is nothing but sh*t. But this change should wait
> until everybody has a chance to have fixed sensors package in their
> distribution.
>
> To be clear, what I'm suggesting is to postpone the change and schedule
> it for something like 3.7.

The sensors update with the fix is scheduled for about a week out, well
before 3.3 ships.

The code in next for 3.4 is perhaps 4-6 months out from a kernel
release.  That seems like plenty of time for distros to get an update
package for sensors together.

Eric
