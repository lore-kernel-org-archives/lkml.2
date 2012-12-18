Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2LRPdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:33:18 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43682 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2LRPdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <20121218151904.GC31255@liondog.tnic>
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
	<CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
	<20121218071317.01cbc41b@tlielax.poochiereds.net>
	<20121218144452.GB31255@liondog.tnic>
	<20121218100702.478fc1b1@tlielax.poochiereds.net>
	<20121218151904.GC31255@liondog.tnic>
Date: Tue, 18 Dec 2012 09:33:15 -0600
Message-ID: <CAH2r5mt622hpU=iC8BL1gvSD-fnjWnE=Qm+pph_AY5ob0zbejQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Do not enable debugging code by default
From: Steve French <smfrench@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 9:19 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Dec 18, 2012 at 10:07:02AM -0500, Jeff Layton wrote:
>> Yeah, not many do, but presumably they'll set it once and forget about
>> it. Once someone straightens them out, they should rarely break.
>>
>> OTOH, the value of defaulting to "N" is pretty low here. Maybe it
>> would just be best to just drop this patch and have the embedded folks
>> turn this off on their own.
>
> Yeah, sure.

I am ok with disabling it for embedded, but probably easier to drop
it.   The real benefit will come when someone familiar with dynamic
trace points comes up with some good examples for file system(s) and
the VFS so we can reduce our dependency on static tracing.



-- 
Thanks,

Steve
