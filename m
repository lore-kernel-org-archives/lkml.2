Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1BSQtI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 11:49:08 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42389 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752471Ab1BSQtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 11:49:05 -0500
Date: Sat, 19 Feb 2011 17:48:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, jiaweiwei.xiyou@gmail.com,
        linux-kernel@vger.kernel.org, joe@perches.com, greg@kroah.com,
        rdunlap@xenotime.net
Subject: Re: [PATCH]move double quotation marks so that keep MAINTAINERS
 consistent
Message-ID: <20110219164839.GA20047@ucw.cz>
References: <20110210025133.GA3285@gmail.com>
 <20110209190631.f29419ef.akpm@linux-foundation.org>
 <20110209.191752.226762899.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209.191752.226762899.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2011-02-09 19:17:52, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 9 Feb 2011 19:06:31 -0800
> 
> > I suspect that some mail clients will explode if you provide them with
> > an unquoted string containing periods.  That would make copy-n-paste
> > rather a hassle.
> 
> It's not clients, it's servers.
> 
> SMTP rules state that characters such as "." cannot appear
> unquoted in email headers.
> 
> vger.kernel.org rejects mail when this violation occurs.

Ok, but should not MUA do this quotation? Quick test shows that mutt does... 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
