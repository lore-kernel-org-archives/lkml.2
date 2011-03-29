Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1C2NUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:20:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab1C2NUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:20:37 -0400
Date: Tue, 29 Mar 2011 06:12:19 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Julian Anastasov <ja@ssi.bg>, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/6] TTY: unify tty_init_dev fail path handling
Message-ID: <20110329131219.GA17294@suse.de>
References: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
 <alpine.LFD.2.00.1103232250160.1634@ja.ssi.bg>
 <4D91CDE6.9060006@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D91CDE6.9060006@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 02:17:42PM +0200, Jiri Slaby wrote:
> On 03/23/2011 09:53 PM, Julian Anastasov wrote:
> > 
> >     Hello,
> > 
> > On Wed, 23 Mar 2011, Jiri Slaby wrote:
> > 
> >> Change it so that we call the deinit functions at one place at the end
> >> of the function (by gotos). And while at it use some sane label names.
> >>
> >> This is a preparation for the deinitialization of tty in the next
> >> patch.
> >>
> >> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> >> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> >> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> >> Cc: Julian Anastasov <ja@ssi.bg>
> >> ---
> >>
> >> This is not tested yet, I'm building a kernel to test it a bit, but it
> >> will take some time. If you could too to check if your problem
> >> dissapears, it would be great.
> > 
> >     Thanks! Patches 1-5 work for me, I backported them
> > to 2.6.33.8 for the test.
> 
> Thanks for testing. I see no regressions either.
> 
> Greg, will you take it?

Yes I will queue it up in a week or so, thanks.

greg k-h
