Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1JWVJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:09:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41631 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1JWVJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:09:17 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stable-review@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Chuck Ebbert <cebbert@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [22/27] VFS: Fix automount for negative autofs dentries
In-Reply-To: <20111023083636.GA14048@suse.de> (Greg KH's message of "Sun, 23
	Oct 2011 10:36:36 +0200")
References: <20111023062833.GA8126@kroah.com>
	<20111023062540.684446582@pistachio.kroah.org>
	<CA+55aFxkHr75LZU0udv=A+Bg52fMMOEfp47TTxHGbgf51UouRg@mail.gmail.com>
	<20111023083636.GA14048@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Sun, 23 Oct 2011 23:09:11 +0200
Message-ID: <87pqhnifew.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Sun, Oct 23, 2011 at 10:35:14AM +0300, Linus Torvalds wrote:
>> This one is debatable.
>> 
>> I think it also wants
>> 
>>  - commit 0ec26fd0698285b31248e34bf1abb022c00f23d6 (with
>> LOOKUP_PARENT->LOOKUP_CONTINUE too)
>
> Really?  I thought I dropped this one from the last stable release due
> to problems with it, or does this patch here, and the one you mention
> below, resolve those issues?
>
>>  - commit d94c177beeb4469cd4f6e83354ab0223353e98ed (to get the few
>> other cases right too)
>> 
>> anything else I missed?
>
> Ok, that makes a bit more sense, I'll add these if David and Miklos
> agree that they are ok to add here.  David and Miklos?

IMO they are OK to add as long as they are both added.

Last time the first one had to be backed out because Linus wasn't
totally comfortable with the other one going into -stable until it got
some testing in 3.1.  Or at least that's how I understood (or
misunderstood).

Thanks,
Miklos
