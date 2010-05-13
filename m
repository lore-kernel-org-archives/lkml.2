Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0EMCPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:15:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57366 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0EMCPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ETfgYpbdn88/2BgL6fysLMswrx6zcGxhLjrNAlR65TeMD0n8HvWG8zDyPfbd/GMlGk
         7JvfbE8XS3XSEsM807tKjEYrYHobMGo+JY1neeWpk4Uh/Ov+7Hp32herCz4jwiM1MJLj
         4dkKFbSHBvu0EtXMZ6WAMHtGAHFzr9mZJ9duk=
MIME-Version: 1.0
In-Reply-To: <201005121919.24115.tfjellstrom@strangesoft.net>
References: <201004261855.29335.tfjellstrom@strangesoft.net>
	 <201005101852.43114.tfjellstrom@strangesoft.net>
	 <4BEB5132.6060201@gmail.com>
	 <201005121919.24115.tfjellstrom@strangesoft.net>
Date: Wed, 12 May 2010 20:14:59 -0600
Message-ID: <AANLkTinMOHdOGbghsZ9thgkXdFW0mQJRwJBu8EJbOB8k@mail.gmail.com>
Subject: Re: burning small isos repeatedly failing with hangcheck error
From: Robert Hancock <hancockrwd@gmail.com>
To: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 7:19 PM, Thomas Fjellstrom
<tfjellstrom@strangesoft.net> wrote:
>> > I do not recall having these issues with older kernels.
>>
>> Same wodim version? The commands (and ordering thereof) it is issuing
>> could have an effect on this..
>
> I can't be certain that its the same version of wodim. I have often noticed
> that it takes far longer to burn a small iso onto a DVDR than you'd
> intuitively think it would, but I've never had this timeout error happen
> prior to 2.6.33, not that that means the problem started with 2.6.33, I
> can't recall how long its been since I last had to burn a really small iso
> to a DVDR.
>
> I can try and test various versions of the kernel and wodim, if you think it
> would help.

I think different wodim versions (or try different software like
growisofs, etc) would be the most promising option. There's really not
a lot of influence the kernel has on this process, the burning
software accesses the device with SG_IO which pretty much just passes
ATAPI commands through to the drive.

I thought I saw a report recently that some version of wodim was
sending uninitialized values as the timeout for SG_IO commands, but I
can't seem to find that mail at the moment..
