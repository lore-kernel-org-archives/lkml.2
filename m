Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab1ETNgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:36:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52101 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933714Ab1ETNgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hrzCheF9RtKvrgkVL1bq5vQH27JCFPn7kC2nDWkjeGPJrnXddrm2QnDcvzMDFjnImd
         EXPKBIPQoSu2fFWygybRNZVu3bKEJIl7IKrdFqUW0OLxBXJHNUbGD/wxLFXAxTfKhzrE
         EMUtfUHReXtA+x6O1DI9YyWs28r6Skk6wHeHI=
Date: Fri, 20 May 2011 17:36:15 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110520133615.GB8112@albatros>
References: <20110518163142.GA3367@albatros>
 <20110518163951.GA24143@suse.de>
 <20110518170545.GA4435@albatros>
 <20110518191727.GA26741@suse.de>
 <20110519062622.GA4418@albatros>
 <20110519171227.GB22019@suse.de>
 <20110520095920.GA4489@albatros>
 <20110520133044.GC10225@suse.de>
 <20110520133451.GA8112@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520133451.GA8112@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 17:34 +0400, Vasiliy Kulikov wrote:
> On Fri, May 20, 2011 at 06:30 -0700, Greg KH wrote:
> > > Correct.  So, if I understood you, you are OK with adding mount options
> > > for debugfs, but not sysfs, right?  What is the difference between them
> > > in sense of permissions?
> > 
> > debugfs is "there are no rules", so changing the permissions on it
> > shouldn't break anything as no userspace tools "should" rely on it.  Now
> > that really isn't true (see the perf stuff), but overall it is, so I
> > don't worry about changing things there as much as sysfs, which has
> > hundreds of tools relying on it.
> 
> What would break if the default behaviour is not changed?

Err... sorry, s/would break/would it break/


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
