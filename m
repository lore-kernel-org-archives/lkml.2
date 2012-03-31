Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413Ab2CaQNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 12:13:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57913 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760272Ab2CaQNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 12:13:42 -0400
X-Sasl-enc: 8cfW10LFKr3I6L6xk9FmkZhrjpgnSdqA33R2zhAHAhp0 1333210421
Date: Sat, 31 Mar 2012 09:13:39 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Phillip Lougher <phil.lougher@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Phillip Lougher <plougher@redhat.com>, linux-kernel@vger.kernel.org,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] sysctl: fix restrict write access to dmesg_restrict
Message-ID: <20120331161339.GK27849@kroah.com>
References: <20120330234317.GC411@lenovo-rd230-04.lab.bos.redhat.com>
 <4F7646DC.8090802@nod.at>
 <20120330175525.eaef1ece.akpm@linux-foundation.org>
 <CA+2-8GAg6x04FyZwNnBbQDhpL5Stwy+s4yZmMYRX8ZCUVjYsvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+2-8GAg6x04FyZwNnBbQDhpL5Stwy+s4yZmMYRX8ZCUVjYsvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 02:58:02AM +0100, Phillip Lougher wrote:
> On Sat, Mar 31, 2012 at 1:55 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > Presumably someone else fiddled with the file, patch(1) misapplied the
> > hunk and I didn't notice.
> >
> 
> That was my guess, the repeated near identical sysfs entries is
> confusing patch.  The stable kernels also suffer from this
> misapplication, but the misapplication is random, for instance I
> noticed here
> 
> http://www.mail-archive.com/stable@linux.kernel.org/msg07097.html
> 
> that the patch has been misapplied to suid_dumpable.  It looks like
> all of the stable kernels need to be separately checked, and if
> necessary different patches need to be generated.

Ok, can someone please do this and send me the patches?  I don't exactly
know what you are referring to here to be able to do it myself...

greg k-h
