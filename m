Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab1DNJsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:48:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55158 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579Ab1DNJsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ODq8a0T0oKtO16AJEBrBeb63OrS4NbTyxAMfFmWYWvfjPGM9bn5sIOe0awCXiSlEp3
         3icBaKGE3hYEGeo8P9xNvdLYBCCh7Bp+pXfMERM0Ep1TBNRdE5sBJfWcquUXuNBW88JL
         mG6NeAMELs4vO4XOdsCqCbPlhrCwJXqVFtd7k=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
Date: Thu, 14 Apr 2011 11:48:49 +0200
Message-ID: <BANLkTi=BLt5evF12J-FQ3GVxnfOiEFJzwg@mail.gmail.com>
Subject: Re: Unionmount status?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Michal Suchanek <hramrach@centrum.cz>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:38 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Apr 13, 2011 at 5:13 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
>> On 13 April 2011 16:18, Jiri Kosina <jkosina@suse.cz> wrote:
>>> https://lkml.org/lkml/2011/3/22/222
>>>
>>
>> Thanks for pointing out this announcement.
>>
>> However, neither this announcement nor the document
>> Documentation/filesystems/overlayfs.txt included in the git tree
>> details how to mount the filesystem. Without that it is kind of
>> useless.
>
> Oh, I'll fix that in the docs.  Thanks for pointing it out.
>
> Here's how to mount:
>
>  mount -t overlayfs overlayfs -olowerdir=/lower -oupperdir=/upper /overlay
>
> Thanks,
> Miklos
>

Hi Miklos,

did you stop working on OverlayFS (no hear no read since 3 weeks :-))?
You made some post-v7-patchset patches, but did not publish a v8.

Also, Linus requested a finer-grained split of the big overlayfs.c
file like in the other FS.
What's the status on this?

Regards,
- Sedat -
