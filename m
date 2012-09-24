Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2IXAi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 20:38:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37307 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215Ab2IXAiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 20:38:54 -0400
X-Sasl-enc: PCiryF1JJkbVWcWR/K4/Qgy90Csc9qxAFd5lFvcALSPi 1348447133
Message-ID: <1348447130.2318.1.camel@perseus.themaw.net>
Subject: Re: [PATCH 0/2] struct pid-ify autofs4
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com
Date: Mon, 24 Sep 2012 08:38:50 +0800
In-Reply-To: <87haqrwfbj.fsf@tucsk.pomaz.szeredi.hu>
References: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
	 <87haqrwfbj.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 17:44 +0200, Miklos Szeredi wrote:
> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> > These two patches change autofs4 to store struct pid pointers instead of pid_t
> > values.
> >
> > Fixed various issues with the previous post.  Not tested, handle with
> > care!
> 
> Customer gave positive test results.

For what exactly, there's no problem description in these patches?

> 
> Thanks,
> Miklos
> 
> >
> > Thanks,
> > Miklos
> > ---
> >
> >
> > Serge Hallyn (1):
> >       autofs4: store struct pids in autofs_waitqs
> >
> > Sukadev Bhattiprolu (1):
> >       Replace pid_t in autofs4 with struct pid reference.
> >
> > ---
> >  fs/autofs4/autofs_i.h  |    8 ++++----
> >  fs/autofs4/dev-ioctl.c |    3 ++-
> >  fs/autofs4/inode.c     |   22 +++++++++++++++-------
> >  fs/autofs4/waitq.c     |   19 +++++++++++++------
> >  4 files changed, 34 insertions(+), 18 deletions(-)


