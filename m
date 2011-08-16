Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1HPLfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 07:35:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46596 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1HPLfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 07:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110816100231.GA28425@1wt.eu>
References: <20110816015447.GA28885@kroah.com>
	<20110816015501.GB28885@kroah.com>
	<alpine.LNX.2.00.1108161110350.23471@swampdragon.chaosbits.net>
	<20110816100231.GA28425@1wt.eu>
Date: Tue, 16 Aug 2011 07:35:21 -0400
Message-ID: <CA+5PVA6hY6=-sLH_=KV5K9mxBrX_Z0stg67vPoVH5sLVuUQ8ag@mail.gmail.com>
Subject: Re: [stable] Linux 3.0.2
From: Josh Boyer <jwboyer@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Jesper Juhl <jj@chaosbits.net>, Greg KH <gregkh@suse.de>, lwn@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 6:02 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Tue, Aug 16, 2011 at 11:11:43AM +0200, Jesper Juhl wrote:
>>
>> > diff --git a/Makefile b/Makefile
>> > index f124b18..794fa28 100644
>> > --- a/Makefile
>> > +++ b/Makefile
>> > @@ -1,6 +1,6 @@
>> >  VERSION = 3
>> >  PATCHLEVEL = 0
>> > -SUBLEVEL = 1
>> > +SUBLEVEL = 2
>> >  EXTRAVERSION =
>>
>> Isn't it time we remove that EXTRAVERSION from the stable kernels now that
>> they are using SUBLEVEL ?
>
> It can be left empty here, it's still used a lot when doing specific builds
> that need to embed a variant name (make bzImage modules EXTRAVERSION=xxx).

Distros still use it as well.  We use it to add in the RPM release number.

josh
