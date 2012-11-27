Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2K0OqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:46:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54529 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab2K0OqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:46:11 -0500
Date: Tue, 27 Nov 2012 06:47:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com, kyungmin.park@samsung.com,
        sachin.kamat@linaro.org, khoroshilov@ispras.ru
Subject: Re: Re: Re: [GIT PULL] extcon for Linux 3.8
Message-ID: <20121127144734.GC27270@kroah.com>
References: <20121127042631.GA17479@kroah.com>
 <1354000869-26589-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354000869-26589-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 04:21:09PM +0900, MyungJoo Ham wrote:
> 
> > On Tue, Nov 27, 2012 at 12:54:30AM +0000, MyungJoo Ham wrote:
> > > > On Thu, Nov 22, 2012 at 01:51:10PM +0900, MyungJoo Ham wrote:
> > > > > Please pull extcon patches for Linux 3.8.
> > > > 
> > > > This is not a signed-tag pull request, which I thought I asked for
> > > > previously.
> > > > 
> > > > Please create that, so that I can properly know I am getting the right
> > > > pull request and patches.
> > > 
> > > A singed tag, "pull_req_20121122", has been already attached at the HEAD
> > > of for-next branch.
> > > 
> > > Would it be more readable if the request is made with
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git tags/pull_req_20121122
> > > rather than
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git for-next
> > > ? (both point to the same commit and I tried the first URL for git request-pull; however git request-pull gives me the second URL as the result)
> > 
> > git request-pull should show you the proper tag, if you are using a new
> > version of git (i.e. something fairly recent.)  What version of git are
> > you using?  How did you create the signed tag?
> > 
> > thanks,
> > 
> > greg k-h
> 
> I'm using 1.7.5.4. 
> 
> And are you talking about the git update of
> "682853e68 request-pull: really favor a matching tag"?
> 
> The process I did for creating request-pull message was:
> 
> $ git tag -U D606808A pull_req_20121122 HEAD
> $ git push --tags
> $ git request-pull f4a75d2eb7b1e2206094b901be09adb31ba63681 git:/git.kernel.org:/pub/scm/linux/kernel/git/mzx/extcon tags/pull_req_20121122 HEAD
> 
> Anyway, with the version 1.7.9.5, it produces messages with proper tag ids.

Yes, that worked, thanks.  There are newer versions of git out there,
you should be using the 1.8 version by now.  You can always just use the
git git tree and install to your local directory, which is what is
recommended for kernel developers, to ensure we have the latest version.

> The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:
> 
>   Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon tags/pull_req_20121122
> 
> ----------------------------------------------------------------
> extcon pull request targetting Linux 3.8 for Greg KH on 2012.11.22
> This is based on Linux 3.7 rc6

Next time can you provide a bit more information here?  I really don't
care what the tree is based on (hint, git request-pull just told me that
above).  See other merges in the kernel tree for examples of good pull
request messages as examples.

Now pulled and pushed out, thanks.

greg k-h
