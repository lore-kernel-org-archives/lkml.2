Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2IYLJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab2IYLJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:09:40 -0400
Message-ID: <1348571366.10028.4.camel@localhost.localdomain>
Subject: Re: [PATCHv3 0/6] media: convert to c99 format
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Date: Tue, 25 Sep 2012 08:09:26 -0300
In-Reply-To: <CALF0-+UZGCpBcGFSyGirdAoKY5MGV-k6c9YefBHfvv5Qk=rTUg@mail.gmail.com>
References: <1347968672-10803-1-git-send-email-shubhrajyoti@ti.com>
	 <CALF0-+UZGCpBcGFSyGirdAoKY5MGV-k6c9YefBHfvv5Qk=rTUg@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Ter, 2012-09-25 às 08:03 -0300, Ezequiel Garcia escreveu:
> Shubhrajyoti,
> 
> Thanks for your patches.
> 
> I'm adding media maintainer (Mauro) in Cc. When you send
> patches for a file you should check who maintains them
> and put those people in Cc.

I actually prefer to not be c/c on the patches ;) Copying the
linux-media mailing list and checking if the patch was caught by
patchwork.linuxtv.kernel.org is enough, as I rely on patchwork to
queue patches for me. So, I just discard any media patch sent to me
directly.

> 
> This is really easy with get_maintainer.pl. You can also
> check with git log / git blame to see who has been working
> on that file.
> 
> You should read Documentation/SubmittingPatches
> if you haven't already (and read it again if you already have ;-)
> 
> On Tue, Sep 18, 2012 at 8:44 AM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> > The series tries to convert the i2c_msg to c99 struct.
> > This may avoid issues like below if someone tries to add an
> > element to the structure.
> > http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg08972.html
> >
> > Special thanks to Julia Lawall for helping it automate.
> > By the below script.
> > http://www.mail-archive.com/cocci@diku.dk/msg02753.html
> >
> > Changelogs
> > - Remove the zero inititialisation of the flags.
> >
> > Shubhrajyoti D (6):
> >   media: Convert struct i2c_msg initialization to C99 format
> >   media: Convert struct i2c_msg initialization to C99 format
> >   media: Convert struct i2c_msg initialization to C99 format
> >   media: Convert struct i2c_msg initialization to C99 format
> >   media: Convert struct i2c_msg initialization to C99 format
> >   media: Convert struct i2c_msg initialization to C99 format
> >
> 
> IMO, sending several different patches with the same commit
> subject is not the best thing to do.
> 
> Perhaps this is too much to ask, but I'd prefer something
> like:
> 
> media: saa7706h: Convert struct i2c_msg initialization to C99 format
> 
> >  drivers/media/i2c/ks0127.c                    |   13 +++++++-
> >  drivers/media/i2c/msp3400-driver.c            |   40 +++++++++++++++++++++----
> >  drivers/media/i2c/tvaudio.c                   |   13 +++++++-
> >  drivers/media/radio/radio-tea5764.c           |   13 ++++++--
> >  drivers/media/radio/saa7706h.c                |   15 ++++++++-
> >  drivers/media/radio/si470x/radio-si470x-i2c.c |   23 ++++++++++----
> >  6 files changed, 96 insertions(+), 21 deletions(-)
> >
> 
> Thanks!
> Ezequiel.

