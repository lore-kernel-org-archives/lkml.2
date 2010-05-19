Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0ESKzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:55:20 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56797 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab0ESKzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YHQ41+MqRmU3qkEoiriAgCSF+g2IRYqPdc9mayjYk5gxxGpKsxa88TQKx0F/gAAdPM
         SnMb3k7ypHH+NHViE3ChpVg86FnCISzrRR0DMwUC0L8/AZ8Ci6oLL7xHf5TviuflU76c
         Eh/YJU1SIe1hnU7wgWMnxWuSpv+msnokNu4io=
Date: Wed, 19 May 2010 12:55:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/4 v2] V4l bkl ioctl pushdown
Message-ID: <20100519105519.GA1213@nowhere>
References: <1274079052-23611-1-git-send-regression-fweisbec@gmail.com> <201005180850.27813.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005180850.27813.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 08:50:27AM +0200, Hans Verkuil wrote:
> On Monday 17 May 2010 08:50:48 Frederic Weisbecker wrote:
> > Hi,
> > 
> > This is the second attempt to pushdown the bkl in v4l fops ioctl
> > handlers.
> > 
> > Amongst the changes:
> > 
> > - keep video_ioctl2() unlocked but bring a new video_ioctl2_bkl()
> >   that drivers can use and attribute to their .unlocked_ioctl instead.
> > 
> > - two new (or it I missed them last time) drivers have been included
> >   to the pushdown.
> > 
> > This is against a fresh v4l/master.
> > 
> > Thanks.
> 
> Other than the single comment about the vivi driver in patch 3/4:
> 
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> It looks good to me and it would be nice if this could be merged for 2.6.35.
> 
> Regards,
> 
> 	Hans


Thanks I'm fixing the issue with the vivi driver and will resend the set
with your acks.

