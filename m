Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0D0XJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:09:35 -0400
Received: from kroah.org ([198.145.64.141]:60916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab0D0XJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:09:07 -0400
Date: Tue, 27 Apr 2010 16:02:28 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, Scott Smedley <ss@aao.gov.au>,
       Greg KH <gregkh@suse.de>, Jason Baldus <jason.baldus@gmail.com>,
       linux-kernel@vger.kernel.org,
       Harley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 1/3] drivers/staging/dt3155: Integrate 3 badly styled
 files into 1 clean file
Message-ID: <20100427230228.GB17260@kroah.com>
References: <20100329032301.GC27607@verge.net.au>
 <cover.1269847733.git.joe@perches.com>
 <ba7a1e2464417043f00f78f6ddaab260c23c3cc9.1269847733.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba7a1e2464417043f00f78f6ddaab260c23c3cc9.1269847733.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 12:34:28AM -0700, Joe Perches wrote:
> Make variables static where appropriate
> Rename dt3155_<foo_with_long_names> variables to dt_<foo_tla>
> to reduce code length and make more lines fit well in 80 chars
> Remove now unnecessary .h files
> Change indent to use tabs
> Remove unused functions
> Used bool more often
> Checkpatch clean

This is too much in one patch, sorry.  It also doesn't apply due to
other changes in these files (that you then remove in patch 3) from
other developers.

thanks,

greg k-h
