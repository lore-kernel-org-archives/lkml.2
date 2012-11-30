Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672Ab2K3PU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:20:57 -0500
Received: from c62.cesmail.net ([216.154.195.54]:36888 "EHLO c62.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030659Ab2K3PU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:20:56 -0500
Message-ID: <20121130102055.ofc76mrlusc0s40g-cebfxv@webmail.spamcop.net>
Date: Fri, 30 Nov 2012 10:20:55 -0500
From: Pavel Roskin <proski@gnu.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        SE-Linux <selinux@tycho.nsa.gov>
Subject: Re: Bisected regression: iterate_fd() selinux change affects flash
	plugin
References: <20121025101416.v1wilj95q8wkk0os-cebfxv@webmail.spamcop.net>
	<20121111235001.a3gqhaijmec0gk0g-cebfxv@webmail.spamcop.net>
	<CACLa4pu4FFwKdoA8ATfmviOj0e0mAQ3U2FNEiJHCv4RfDY4ZoQ@mail.gmail.com>
	<20121112115707.r8h545480kg0cgkk-cebfxv@webmail.spamcop.net>
	<CACLa4pvixB3Ehz-Ds+opvMF73pNwQJxpNx=02qy94ufJag2qwA@mail.gmail.com>
	<20121130034034.GB4939@ZenIV.linux.org.uk>
	<20121130040240.GC4939@ZenIV.linux.org.uk>
In-Reply-To: <20121130040240.GC4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Al Viro <viro@ZenIV.linux.org.uk>:

> On Fri, Nov 30, 2012 at 03:40:34AM +0000, Al Viro wrote:
>
>> The bug is real, but Pavel's patch is all wrong.  The problem is in the
>> argument; we should pass descriptor number, not descriptor + 1.  And fixing
>> that (in iterator_fd() itself) makes all callbacks work as they ought to.
>>
>> PS: Pavel, the life is painful enough as it is, no need to involve BZ into
>> it.  Next time you need to post a patch, please do just that, especially
>> when it's so short, OK?
>
> See tonight's vfs.git#for-linus; the head is at commit a77cfcb.

Works for me!  Thank you!  Sorry if I mishandled anything.

-- 
Regards,
Pavel Roskin
