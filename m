Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2IYLEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:04:01 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55664 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IYLD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:03:58 -0400
MIME-Version: 1.0
In-Reply-To: <1347968672-10803-1-git-send-email-shubhrajyoti@ti.com>
References: <1347968672-10803-1-git-send-email-shubhrajyoti@ti.com>
Date: Tue, 25 Sep 2012 08:03:57 -0300
Message-ID: <CALF0-+UZGCpBcGFSyGirdAoKY5MGV-k6c9YefBHfvv5Qk=rTUg@mail.gmail.com>
Subject: Re: [PATCHv3 0/6] media: convert to c99 format
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shubhrajyoti,

Thanks for your patches.

I'm adding media maintainer (Mauro) in Cc. When you send
patches for a file you should check who maintains them
and put those people in Cc.

This is really easy with get_maintainer.pl. You can also
check with git log / git blame to see who has been working
on that file.

You should read Documentation/SubmittingPatches
if you haven't already (and read it again if you already have ;-)

On Tue, Sep 18, 2012 at 8:44 AM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> The series tries to convert the i2c_msg to c99 struct.
> This may avoid issues like below if someone tries to add an
> element to the structure.
> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg08972.html
>
> Special thanks to Julia Lawall for helping it automate.
> By the below script.
> http://www.mail-archive.com/cocci@diku.dk/msg02753.html
>
> Changelogs
> - Remove the zero inititialisation of the flags.
>
> Shubhrajyoti D (6):
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>

IMO, sending several different patches with the same commit
subject is not the best thing to do.

Perhaps this is too much to ask, but I'd prefer something
like:

media: saa7706h: Convert struct i2c_msg initialization to C99 format

>  drivers/media/i2c/ks0127.c                    |   13 +++++++-
>  drivers/media/i2c/msp3400-driver.c            |   40 +++++++++++++++++++++----
>  drivers/media/i2c/tvaudio.c                   |   13 +++++++-
>  drivers/media/radio/radio-tea5764.c           |   13 ++++++--
>  drivers/media/radio/saa7706h.c                |   15 ++++++++-
>  drivers/media/radio/si470x/radio-si470x-i2c.c |   23 ++++++++++----
>  6 files changed, 96 insertions(+), 21 deletions(-)
>

Thanks!
Ezequiel.
