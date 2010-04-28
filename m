Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0D1FaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 01:30:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1753 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0D1FaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 01:30:05 -0400
Subject: Re: [PATCH 1/3] drivers/staging/dt3155: Integrate 3 badly styled
 files into 1 clean file
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: devel@driverdev.osuosl.org, Scott Smedley <ss@aao.gov.au>,
       Greg KH <gregkh@suse.de>, Jason Baldus <jason.baldus@gmail.com>,
       linux-kernel@vger.kernel.org,
       Harley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>
In-Reply-To: <20100427230228.GB17260@kroah.com>
References: <20100329032301.GC27607@verge.net.au>
	 <cover.1269847733.git.joe@perches.com>
	 <ba7a1e2464417043f00f78f6ddaab260c23c3cc9.1269847733.git.joe@perches.com>
	 <20100427230228.GB17260@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 22:30:03 -0700
Message-ID: <1272432603.23132.30.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 16:02 -0700, Greg KH wrote:
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
> This is too much in one patch, sorry.

You should be more consistent.

http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel
Greg even said, "submit one big patch if you want"


> It also doesn't apply due to
> other changes in these files (that you then remove in patch 3) from
> other developers.

No, it doesn't apply because you chose to apply other patches
before this one.


