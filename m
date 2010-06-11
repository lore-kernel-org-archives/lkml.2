Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0FKQqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:46:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32927 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab0FKQqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:46:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ELkmP/9J+QvODDhCWOW2G7DAPbMo5ynni7Ju48zKyz0QocI3Zv22d8bIJP0RDqxZ0g
         31R3GnZBCA/vL21Ymud4n8X4TRj8MiSvH8gVILLguFUL8WI2ktkoeK6XsQFRQYcWLXRV
         R1ifd07B+PueEKjsPSQrNQd+OEFVpbD0DfmwY=
MIME-Version: 1.0
In-Reply-To: <4C125A6C.2090805@redhat.com>
References: <4C119C2E.2090801@oracle.com>
	<4C11B6D8.8070909@redhat.com>
	<4C11C41C.9070000@oracle.com>
	<4C125A6C.2090805@redhat.com>
Date: Fri, 11 Jun 2010 12:46:44 -0400
Message-ID: <AANLkTim9xIyL842wapccPIwEPVgd3BY8_r0tBGfGgvOt@mail.gmail.com>
Subject: Re: fiemap is broken for sparse file in ext4?
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Tao Ma <tao.ma@oracle.com>, linux-ext4@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 11:46 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> Tao Ma wrote:
>
>>> What are you using to call fiemap?  Here it seems to be working:
>> I just wrote a simple test program by calling ioctl. It is attached.
>> btw, you need to call it immediately after dd so that we have a chance
>> that ext4 don't have time to allocate extents. ;)
>
> OK I take it back, I do see it.  *cough* too many different filesystems
> on this box ... ;)
>
> Yes, it does look like a bug.
>
> -Eric

I'm not clear how this is supposed to work.

Is this just a userspace bug in that FIEMAP_FLAG_SYNC is needed in the
fiemap call, or is there a kernel bug as well?

If fiemap is called with the FIEMAP_FLAG_SYNC flag is there currently a problem?

Thanks
Greg
