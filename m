Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab1ETNe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:34:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39586 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851Ab1ETNez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dmgKN4hov+O/Miad6qW59U83XRublkIow85Mo+9KYePxVSu1s7wpNm19NWvR0/K+Qn
         95k2Bx6L+jVHBW/LB/o3zCn2nmZ5lVBDoyKa9U6ot1r+VsE1bbkwzeTEqLUrwVysRY+w
         e8fYgpCeFzV16NPwOO3mRFLUCGB9vEeO2gz10=
Date: Fri, 20 May 2011 17:34:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110520133451.GA8112@albatros>
References: <20110518163142.GA3367@albatros>
 <20110518163951.GA24143@suse.de>
 <20110518170545.GA4435@albatros>
 <20110518191727.GA26741@suse.de>
 <20110519062622.GA4418@albatros>
 <20110519171227.GB22019@suse.de>
 <20110520095920.GA4489@albatros>
 <20110520133044.GC10225@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520133044.GC10225@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 06:30 -0700, Greg KH wrote:
> > > > Here https://lkml.org/lkml/2011/2/25/300 you, not aware of usefull
> > > > applications of world-writable debugfs file, agreeded to statically
> > > > restrict permissions of all files.  I suggest more flexible and
> > > > configurable in runtime solution.  It doesn't break anything - default
> > > > behaviour doesn't differ from current one.  What has changed in your
> > > > mind since 2/25?
> > > 
> > > That's debugfs, not sysfs, which we are talking about here, right?
> > 
> > Correct.  So, if I understood you, you are OK with adding mount options
> > for debugfs, but not sysfs, right?  What is the difference between them
> > in sense of permissions?
> 
> debugfs is "there are no rules", so changing the permissions on it
> shouldn't break anything as no userspace tools "should" rely on it.  Now
> that really isn't true (see the perf stuff), but overall it is, so I
> don't worry about changing things there as much as sysfs, which has
> hundreds of tools relying on it.

What would break if the default behaviour is not changed?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
