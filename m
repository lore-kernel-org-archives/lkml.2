Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0LaVrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 16:47:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47122 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0LaVrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 16:47:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wjXVkrvHiXuQx39Nr763m0KQEAAv1eiVaurbGBR7vJr30JWT4ALgI81YytzLcJKei5
         SBEPRtlKfy9eQm8jrpyxlpoYBX1YHVqNNgpl5bJFnCmLLtndfsg4sO4FZcvUMExFV/B1
         y7/lh/VOQnBFbG2sOdLj/J6Utug4qGkkuwXWA=
Subject: Re: is there a fix for ubuntu with intel GPU booting to blank
 screen?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Anca Emanuel <anca.emanuel@gmail.com>,
        Ubuntu kernel team mailing list 
	<kernel-team@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
In-Reply-To: <alpine.DEB.2.00.1012311153190.3495@localhost6.localdomain6>
References: <alpine.DEB.2.00.1012270640240.3071@localhost6.localdomain6>
	 <AANLkTiktLCVQgGPCyt-fwVSkVmr8Ljr08UmvtkNG_zdp@mail.gmail.com>
	 <alpine.DEB.2.00.1012310836370.23681@localhost6.localdomain6>
	 <1293814089.6993.4.camel@maxim-laptop>
	 <alpine.DEB.2.00.1012311153190.3495@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 23:46:54 +0200
Message-ID: <1293832014.27359.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-31 at 12:01 -0500, Robert P. J. Day wrote:
> On Fri, 31 Dec 2010, Maxim Levitsky wrote:
> 
> ... snip related to i915 blank screen issues ...
> 
> > Since you know how to compile kernel, and even have a close working
> > version, you really should just bisect the bug.
> >
> > Bisection is a built-in in the git binary search that allows you to
> > find the first commit that introduced the bug.
> >
> > For example, quick google gives,
> > http://www.kernel.org/pub/software/scm/git-core/docs/v1.0.13/howto/isolate-bugs-with-bisect.txt
> 
>   oh, i know how to do bisection but, to be frank, i just don't have
> the time.  i'm under a brutal deadline for some billable work and,
> even if i had the time, i suspect that when i eventually tracked down
> the commit, i probably wouldn't really appreciate what i was looking
> at, anyway.
You truly underestimate this.
Having commit that broke things points perfectly at the issue.
Then, developers can even just revert the offending commit until it is
understood why it breaks stuff.

I have done many bisections in the past, and lot of bugs were fixed that
way.

I personally can't help you with the issue, because I am nether familiar
with the hardware nor with the driver, but I just say what I do when I
get a regression (and this not uncommon).

Best regards,
	Maxim Levitsky



> 
>   i've done some searching on the issue and, among other pages, i've
> come up with this one:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/683775
> 
> so i downloaded the kernel mentioned there and tested that, but no
> luck.  mostly, i understand that there top men -- *top* *men* --
> working on this :-) who know far more about the graphics subsystem
> than i do so i'm just going to stay out of their way, but i'm willing
> to test any proposed solutions if they come up.  my biggest worry is
> that, given that we're already at -rc8, will this issue be fixed
> before the next official release?
> 
> rday
> 


