Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab2GFSqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:46:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51928 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2GFSqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:46:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120706175501.GA11908@kroah.com>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
	<20120706175501.GA11908@kroah.com>
Date: Fri, 6 Jul 2012 21:46:10 +0300
Message-ID: <CAGoecWyN_3yvZ4zcWFnsSxzs+4FVo8uTmP6K8oMrhz9ejELjcw@mail.gmail.com>
Subject: Re: Bug 44211 - /proc/kmsg does not (always) block for 1-byte reads
From: Jukka Ollila <jiiksteri@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kay@vrfy.org, jbeulich@novell.com,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 8:55 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Jul 06, 2012 at 08:45:44PM +0300, Jukka Ollila wrote:
>> A few days ago I filed a kernel regression report concerning a change
>> in /proc/kmsg behaviour with short reads:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=44211

> I think we just fixed this, what kernel version are you seeing this
> problem on?

It's still there. Pulled a fresh tree, this is
1b7fa4c27111757789b21bb78543317dad4cfd08 from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

So if this is actually not intentional and getting fixed instead, the
changes haven't made their way upstream yet.

Thanks,

-J
