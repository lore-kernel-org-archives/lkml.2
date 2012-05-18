Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968126Ab2ERWFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:05:10 -0400
Received: from 1wt.eu ([62.212.114.60]:2382 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966112Ab2ERWFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:05:08 -0400
Date: Sat, 19 May 2012 00:04:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <greg@kroah.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/53] 3.2.18-stable review
Message-ID: <20120518220445.GA28901@1wt.eu>
References: <20120518023254.339945758@decadent.org.uk> <20120518144657.GA18264@home.goodmis.org> <20120518182256.GC31313@kroah.com> <1337378456.4107.101.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337378456.4107.101.camel@deadeye>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, May 18, 2012 at 11:00:56PM +0100, Ben Hutchings wrote:
> On Fri, 2012-05-18 at 11:22 -0700, Greg KH wrote:
(...)
> > Ben, care to put the tarball somewhere so I can update it, or should I
> > be poking the kernel.org admins to get you write access to this
> > directory (I think the later would be best...)
> 
> Seems like it might be easier for everyone if I would just send the rc1
> combined patch in email.  Anyway, here it is as an attachment.

I too think that sending rc patches along with the email is better,
especially for longterm branches which tend to see their patch size
drop quickly. In fact it offers more flexibility for sending updates
when something is known to be broken, and I'm really not convinced
at all that anyone downloads the longterm pre-releases without having
received the announcement email !

Just my 2 cents,
Willy

