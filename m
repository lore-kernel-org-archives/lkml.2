Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890Ab2EWVfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:35:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54212 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2EWVfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:35:37 -0400
Message-ID: <4FBD5826.3070004@garzik.org>
Date: Wed, 23 May 2012 17:35:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 3.5
References: <20120523192826.GA4447@havoc.gtf.org> <CA+55aFyTDK50z7sCfRD_nzAKmWpjABxRx1f=j8i9jUUXNgHjzg@mail.gmail.com>
In-Reply-To: <CA+55aFyTDK50z7sCfRD_nzAKmWpjABxRx1f=j8i9jUUXNgHjzg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 05:06 PM, Linus Torvalds wrote:
> On Wed, May 23, 2012 at 12:28 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>>
>> Please pull 2fff27512600f9ad91335577e485a8552edb0abf from
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tag/upstream-linus
>
> That's not what I get at all. I get your old stuff that I pulled early May.
>
> I suspect you didn't force the tag update: tags aren't like branches,
> so by default git will not just overwrite an old tag with a new tag.
> Branches are *expected* to be mutable (well, at least if the changes
> are fast-forwards), after all - but changing a tag is something you
> need to be conscious about.

hmmm, can you try again?  The output of

http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=summary

and

http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=tag;h=4560c1c455fb87ba3013967d6ed5d0b1d18cc109

looks correct, so I think there was a mirroring delay.

	Jeff


