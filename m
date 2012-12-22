Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094Ab2LVHUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 02:20:08 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:50128 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750799Ab2LVHUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 02:20:07 -0500
Message-ID: <1356160806.5754.4.camel@joe-AO722>
Subject: Re: [PATCH 2/2] staging/media: Fix trailing statements should be on
 next line in go7007/go7007-fw.c
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Dec 2012 23:20:06 -0800
In-Reply-To: <20121221184311.2da34111@redhat.com>
References: <1352115526-8287-1-git-send-email-yamanetoshi@gmail.com>
	 <1352115573-8321-1-git-send-email-yamanetoshi@gmail.com>
	 <20121221184311.2da34111@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 18:43 -0200, Mauro Carvalho Chehab wrote:
> Em Mon,  5 Nov 2012 20:39:33 +0900
> YAMANE Toshiaki <yamanetoshi@gmail.com> escreveu:
> 
> > fixed below checkpatch error.
> > - ERROR: trailing statements should be on next line
> > 
> > Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> > ---
> >  drivers/staging/media/go7007/go7007-fw.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
> > index f99c05b..cfce760 100644
> > --- a/drivers/staging/media/go7007/go7007-fw.c
> > +++ b/drivers/staging/media/go7007/go7007-fw.c
> > @@ -725,7 +725,8 @@ static int vti_bitlen(struct go7007 *go)
> >  {
> >  	unsigned int i, max_time_incr = go->sensor_framerate / go->fps_scale;
> >  
> > -	for (i = 31; (max_time_incr & ((1 << i) - 1)) == max_time_incr; --i);
> > +	for (i = 31; (max_time_incr & ((1 << i) - 1)) == max_time_incr; --i)
> > +		;
> 
> Nah, this doesn't sound right to me. IMO, in this specific case,
> checkpatch.pl did a bad job.

Is this even guaranteed to exit the loop?
Maybe using ffs would be more sensible.


