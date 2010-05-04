Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105Ab0EDT2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 15:28:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:50722 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0EDT2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 15:28:22 -0400
Date: Tue, 4 May 2010 12:12:23 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Marin Mitov <mitov@issp.bas.bg>
Subject: Re: linux-next: Tree for May 4 (staging/dt3155v4l)
Message-ID: <20100504191223.GB13208@suse.de>
References: <20100504162305.4a07a18a.sfr@canb.auug.org.au>
 <20100504113604.fe00959d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504113604.fe00959d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 11:36:04AM -0700, Randy Dunlap wrote:
> On Tue, 4 May 2010 16:23:05 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100503:
> 
> 
> drivers/staging/dt3155v4l/dt3155v4l.c:73: error: implicit declaration of function 'udelay'
> drivers/staging/dt3155v4l/dt3155v4l.c:616: warning: assignment from incompatible pointer type
> drivers/staging/dt3155v4l/dt3155v4l.c:1270: error: implicit declaration of function 'msleep'

Ick.  What arch was this?

thanks,

greg k-h
