Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0KDU6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:58:45 -0400
Received: from smtp.scorch.co.nz ([27.110.127.199]:38371 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751849Ab0KDU6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:58:43 -0400
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
Date: Fri, 5 Nov 2010 09:58:38 +1300
User-Agent: KMail/1.9.10
Cc: cdhmanning@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-2-git-send-email-cdhmanning@gmail.com> <20101103174607.GA6777@kroah.com>
In-Reply-To: <20101103174607.GA6777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201011050958.39020.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 November 2010 06:46:07 Greg KH wrote:
> On Thu, Nov 04, 2010 at 05:53:16AM +1300, cdhmanning@gmail.com wrote:
> > From: Charles Manning <cdhmanning@gmail.com>
> >
> > Adding yaffs2 file system.
> >
> > Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> > ---
> >  fs/yaffs2/Kconfig  |  190
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++ fs/yaffs2/Makefile |
> >   17 +++++
>
> Don't do this as your first patch, make it your last one.  Otherwise the
> build will break when you apply this one to the tree.
> Remember, we need to be able to have a correct build at every patch in
> the whole development series, otherwise tools like 'git bisect' will not
> work properly.

I left the actual hook in to the tree building to the last patch which changes 
fs/Kconfig and fs/Makefile.  Thus building the whole of Linux would not 
break.

I suppose the best is to put all the Kconfigs and Makefile changes in the last 
patch.

>
> Also, is your goal to get this cleaned up good enough to get it into .38
> in the "real" place in the kernel, or do you want to see it go through
> staging and take a bit longer to get everything cleaned up properly
> before moving to the "real" location?

My goal it to get this into mainline, .38 preferred.

I am a complete newbie when it comes to this process. What's the best path to 
getting there? 

My preference is to keep cleaning up code in yaffs.net and patching from there 
as this will keep the trees closer together and minimise clerical issues.

It is also a goal to keep the multi-kernel version of the code going in 
yaffs.net so  that there is always a backport on tap. This is an important 
issue for the embedded folk.

>From what you have said it sounds like skipping staging might be better, but I 
have insufficient understanding of the process to understand why. I'll talk 
to some people I know that understand this better.

Thanks

Charles

