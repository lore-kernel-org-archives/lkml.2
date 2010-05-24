Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0EXSwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:52:44 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:51072 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab0EXSwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iRDYhkZaRrFsDKK9UAvwA+YVlpXWSwWcqqcfcry+U7zHXXONWrwSwoAsplGvPfgRt8
         gB4SzLW7o/iE/VOfxbkdVhguMYm+MTkfrdOmFcwkS3EmtfHX4lPytHgZd7GAuO8/o0DN
         1XrP+QXFOotWgtCRuVOxjqEHK1K68nu4zUmt0=
MIME-Version: 1.0
In-Reply-To: <20100524185000.GB8627@kroah.com>
References: <1274582948-11499-1-git-send-email-vapier@gentoo.org> 
	<20100524185000.GB8627@kroah.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 24 May 2010 14:52:20 -0400
Message-ID: <AANLkTikTa6IEg6CLJUvERqWEhsXWApB2XQuOJJ4PLMcr@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [stable] [PATCH] USB: musb: fix Blackfin 
	building after power updates
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-usb@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Felipe Balbi <felipe.balbi@nokia.com>, stable-review@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 14:50, Greg KH wrote:
> On Sat, May 22, 2010 at 10:49:08PM -0400, Mike Frysinger wrote:
>> From: Ian Jeffray <ian@jeffray.co.uk>
>>
>> The new MUSB power code needs musb_read_txhubport() to return a value (so
>> stub it as 0 like the other Blackfin hub funcs).  It also needs new helper
>> functions for saving/restoring context, so change the apparently unused
>> musb_platform_{suspend,resume} to musb_platform_{save,restore}_context in
>> the Blackfin code.
>>
>> Signed-off-by: Ian Jeffray <ian@jeffray.co.uk>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> Note: this is for 2.6.34.x and 2.6.35
>> Note: i believe this is what we want, but Cliff is free to correct me ;)
>>
>>  drivers/usb/musb/blackfin.c  |   12 ++++++++++++
>>  drivers/usb/musb/musb_regs.h |    3 ++-
>
>
> Note, I'm refusing to take any musb patch unless it comes from Felipe
> due to the constant bickering from a number of the musb developers,
> which is starting to really annoy me and contemplate warming up my kill
> file...
>
> So please work with him to get this agreed apon and have him forward it
> to me when ready, that's the only way I'm going to accept it.

this patch is already dead pending whatever Felipe merges (as Sergei
pointed out).  so i'm waiting for him too ;).
-mike
