Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1AZQrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:47:09 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48483 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab1AZQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:47:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qJjvN0eQlQKGJtXHln1oGn331xuh1RS9YAbJxDqlwuu+aF0gpD5JtTJ3ubaF6MXZx6
         tvOcuAGDGAVHnLE3nTny6qI887PGQSHwCq8/0wTWQxYi2f8o4QYDTOZVN4jlQJJ1c1+0
         Rf+kB8Qb2EEXqidd2GdJ4FTw+ipt7nhsYuLLQ=
Date: Wed, 26 Jan 2011 08:46:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126164657.GB29163@core.coreip.homeip.net>
References: <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D4004F9.6090200@redhat.com>
 <4D401CC5.4020000@redhat.com>
 <4D402D35.4090206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D402D35.4090206@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 12:18:29PM -0200, Mauro Carvalho Chehab wrote:
> Em 26-01-2011 11:08, Gerd Hoffmann escreveu:
> >   Hi,
> > 
> >> Btw, I took some time to take analyse the input-kbd stuff.
> >> As said at the README:
> >>
> >>     This is a small collection of input layer utilities.  I wrote them
> >>     mainly for testing and debugging, but maybe others find them useful
> >>     too :-)
> >>     ...
> >>     Gerd Knorr<kraxel@bytesex.org>  [SUSE Labs]
> >>
> >> This is an old testing tool written by Gerd Hoffmann probably used for him
> >> to test the V4L early Remote Controller implementations.
> > 
> > Indeed.
> > 
> >> The last "official" version seems to be this one:
> >>     http://dl.bytesex.org/cvs-snapshots/input-20081014-101501.tar.gz
> > 
> > Just moved the bits to git a few days ago.
> > http://bigendian.kraxel.org/cgit/input/
> > 
> > Code is unchanged since 2008 though.
> > 
> >> Gerd, if you're still maintaining it, it is a good idea to apply Dmitry's
> >> patch:
> >>     http://www.spinics.net/lists/linux-input/msg13728.html
> > 
> > Hmm, doesn't apply cleanly ...
> 
> I suspect that Dmitry did the patch against the Debian package, based on a 2007
> version of it, as it seems that Debian is using an older version of the package.

Actually it was from Ubuntu, so it is based on 2008 checkout, but they
also have more patches, take a peek here:

https://launchpad.net/ubuntu/+archive/primary/+files/input-utils_0.0.20081014-1.debian.tar.gz

Thanks.

-- 
Dmitry
