Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029Ab2CSWqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:46:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2CSWqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:46:50 -0400
Date: Mon, 19 Mar 2012 15:46:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-Id: <20120319154649.0687f545.akpm@linux-foundation.org>
In-Reply-To: <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
References: <20120316205556.595309230@openvz.org>
	<20120316210343.925446961@openvz.org>
	<20120319151507.93bab32a.akpm@linux-foundation.org>
	<20120319223941.GJ19594@moon>
	<CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 23:41:36 +0100
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> On Mon, Mar 19, 2012 at 11:39 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > On Mon, Mar 19, 2012 at 03:15:07PM -0700, Andrew Morton wrote:
> > ...
> >> >
> >> > Also this action is one-shot only. For security reason
> >> > we don't allow to change the symlink several times.
> >>
> >> What is this mysterious "security reason"?
> >>
> >
> > Oh, sorry I should have included Matt's comment here

Please send a patch with the updated changelog and improved comment?

> >
> > Actually I liked multi-shot version more but Matt arguments convinced
> > me that one-short fashion is more "secure" in terms of overall kernel
> > state and potential transitions/changes of this /proc/pid/exe symlink.
> >
> > At least with one-shot version the admin may be sure that the symlink
> > is never changed more than once, ever.
> >
> 
> And changing it once does not harm security?
> I'm sure that rootkit writers will like this feature...

Well, let's discuss this more completely.  In what ways could an
attacker use this?  How serious is the problem?  What actions can be
taken to lessen it?  etcetera.
