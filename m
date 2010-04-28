Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab0D1MTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 08:19:32 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55789 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0D1MTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 08:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kDYNdYNs65nVnJjMuPsoHAPbLzXOUGcme6XPb1fEuhFfNkfAlg8DlWB8+xelhYHJqV
         K/RF62tF/I/gaKad6oLaM3TsEFVijZYJEryEDGX9xLqtNJqq32NWBkVNmWdUksoVdJAs
         haMFWXxCbj1/1mf8zz+Ov8VSgdTfTgH2ljtA8=
Date: Wed, 28 Apr 2010 14:18:52 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       Scott Smedley <ss@aao.gov.au>, Greg KH <gregkh@suse.de>,
       Jason Baldus <jason.baldus@gmail.com>, linux-kernel@vger.kernel.org,
       Harley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 1/3] drivers/staging/dt3155: Integrate 3 badly styled
	files into 1 clean file
Message-ID: <20100428121851.GB24513@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg KH <greg@kroah.com>, Joe Perches <joe@perches.com>,
	devel@driverdev.osuosl.org, Scott Smedley <ss@aao.gov.au>,
	Greg KH <gregkh@suse.de>, Jason Baldus <jason.baldus@gmail.com>,
	linux-kernel@vger.kernel.org,
	Harley Sweeten <hsweeten@visionengravers.com>,
	Simon Horman <horms@verge.net.au>
References: <20100329032301.GC27607@verge.net.au> <cover.1269847733.git.joe@perches.com> <ba7a1e2464417043f00f78f6ddaab260c23c3cc9.1269847733.git.joe@perches.com> <20100427230228.GB17260@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427230228.GB17260@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 04:02:28PM -0700, Greg KH wrote:
> On Mon, Mar 29, 2010 at 12:34:28AM -0700, Joe Perches wrote:
> > Make variables static where appropriate
> > Rename dt3155_<foo_with_long_names> variables to dt_<foo_tla>
> > to reduce code length and make more lines fit well in 80 chars
> > Remove now unnecessary .h files
> > Change indent to use tabs
> > Remove unused functions
> > Used bool more often
> > Checkpatch clean
> 
> This is too much in one patch, sorry.  It also doesn't apply due to
> other changes in these files (that you then remove in patch 3) from
> other developers.
> 

What I like is when people send in a patch that addresses all the white
space issues at once.  So from the above list it would probably fix these:

> > to reduce code length and make more lines fit well in 80 chars
> > Change indent to use tabs
> > Checkpatch clean

I have a script to check that a patch only changes whitespace and I can
check that directly from mutt.  It's in the my smatch repo:  
git://repo.or.cz/smatch.git under smatch_scripts/whitespace_only.sh

If that passes and the source still compiles then I'm pretty sure it 
doesn't break anything.  At that point I can look through it focusing on
the whitespace instead of worrying that the patch introduces bugs.

Once the whitespace is fixed the rest of the changes can be sent in 
separately and they're much smaller and easier to audit.

regards,
dan carpenter

