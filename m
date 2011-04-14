Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab1DNJ6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:58:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50289 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab1DNJ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type;
        b=jZhuuaI3DvbAlmXzbVjIzn95UiCSExeROeZ8eeOgYX/nTSWQr0ThCs8BsM6NfeAX5s
         92OJWAFYjKXpQ7L8keOF7TKpej5ZauAGO3iBN21jfTzB9KWK4CGSvZj61Du+O/pVkn05
         3OTPeMtt6oRlD0H/XJdYLP2ZMMAv6Oydv7ujs=
MIME-Version: 1.0
X-Originating-IP: [88.209.222.127]
In-Reply-To: <BANLkTi=BLt5evF12J-FQ3GVxnfOiEFJzwg@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
	<BANLkTi=BLt5evF12J-FQ3GVxnfOiEFJzwg@mail.gmail.com>
Date: Thu, 14 Apr 2011 11:58:07 +0200
Message-ID: <BANLkTin-L4ON5JZp3A80ptxXZ03NR2E0yg@mail.gmail.com>
Subject: Re: Unionmount status?
From: Miklos Szeredi <miklos@szeredi.hu>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Michal Suchanek <hramrach@centrum.cz>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:48 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> did you stop working on OverlayFS (no hear no read since 3 weeks :-))?
> You made some post-v7-patchset patches, but did not publish a v8.
>
> Also, Linus requested a finer-grained split of the big overlayfs.c
> file like in the other FS.
> What's the status on this?

I'm working on that.  Will post patches shortly.

Thanks,
Miklos
