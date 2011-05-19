Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab1ESG03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 02:26:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36029 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab1ESG01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 02:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t9DzfgDNLMarQVsxRPgeHcqsf5De/O0TYRF1v+wdPdWKjUBrbuA5ssRVZpH0BajmqY
         4rE5jzPQX/aOHCE7ElKh382nZT0htr0NlfGwOj2BDZ0rmuX3LUSOLcM/K4+ZALK/4AJD
         IyjL/tay4eAwTmONpzPqMBBv5ceqGyRuGc5yo=
Date: Thu, 19 May 2011 10:26:23 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110519062622.GA4418@albatros>
References: <20110518163142.GA3367@albatros>
 <20110518163951.GA24143@suse.de>
 <20110518170545.GA4435@albatros>
 <20110518191727.GA26741@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518191727.GA26741@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:17 -0700, Greg KH wrote:
> > 1) *IF* another sensitive file with weird permissions is found, mount
> > option is IMO the best temporary workaround.
> 
> Maybe, but fixing the file would be the obvious solution.

I mean for a sysadmin, not for a developer.


What do you mean by "breaking system"?  Root is able to chmod
and chown sysfs files already, he may do "chmod -R" or similar.
I suggest sane, race free way to globally restrict permissions *IF* root
wants it.

Here https://lkml.org/lkml/2011/2/25/300 you, not aware of usefull
applications of world-writable debugfs file, agreeded to statically
restrict permissions of all files.  I suggest more flexible and
configurable in runtime solution.  It doesn't break anything - default
behaviour doesn't differ from current one.  What has changed in your
mind since 2/25?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments 
