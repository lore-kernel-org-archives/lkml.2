Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2CHVZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:25:34 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:41214 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2CHVZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:25:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <20120130222717.GA6393@kroah.com>
	<m18vkoirv9.fsf@fess.ebiederm.org> <4F27C6EB.2070305@suse.cz>
	<m14nvc82jo.fsf@fess.ebiederm.org>
	<CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
	<m1wr87ywex.fsf@fess.ebiederm.org>
	<m1ehueyz20.fsf_-_@fess.ebiederm.org>
	<CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
	<CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
	<4F54BFEC.6000206@suse.cz> <20120305160953.GA3870@kroah.com>
Date: Thu, 08 Mar 2012 13:28:44 -0800
In-Reply-To: <20120305160953.GA3870@kroah.com> (Greg Kroah-Hartman's message
	of "Mon, 5 Mar 2012 08:09:53 -0800")
Message-ID: <m1boo6ye7n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+IVFnazGfuWSr7xHt+7PLfmxMq41009bI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] sysfs: Optionally count subdirectories to support buggy applications
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Mon, Mar 05, 2012 at 02:30:20PM +0100, Jiri Slaby wrote:
>> On 02/02/2012 12:18 AM, Linus Torvalds wrote:
>> > On Wed, Feb 1, 2012 at 3:15 PM, Linus Torvalds
>> > <torvalds@linux-foundation.org> wrote:
>> >>
>> >> No extra "keep track of inode counts by hand" crap, and no idiotic
>> >> config options that just make it easy to (conditionally) get things
>> >> wrong. Just do it right, and do it *unconditionally* right.
>> > 
>> > And btw, "nlink shows number of subdirectories" for a directory entry
>> > really *is* right. It's how Unix filesystems work, like it or not.
>> > 
>> > It's mainly lazy/bad filesystems that set nlink to 1. So the whole
>> > "nlink==1" case is meant for crap like FAT etc, not for a filesystem
>> > that we control and that could easily just do it right.
>> > 
>> > Which is why I detest that config option. It's as if you were asking the user
>> > 
>> >  "Do you want to make the sysfs filesystem act like crap filesystems?"
>> > 
>> > and kernel config time. What kind of inane question is that?
>> 
>> <thread resumed...>
>> 
>> What's going on here? I still have to revert "sysfs: Kill nlink
>> counting." with today's -next to have working sensors.
>
> I don't remember.  I thought there was a proposed patch for this issue
> from Eric, but I don't see it in my queue anywhere.
>
> Eric, what was the resolution here?

Apologies. Cold/Allergies and distractions have kept it away.
sysfs patches in a follow up.

Eric
