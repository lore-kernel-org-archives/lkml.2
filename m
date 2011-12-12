Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1LLTLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:11:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab1LLTK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:10:57 -0500
Date: Mon, 12 Dec 2011 11:05:26 -0800
From: Greg KH <gregkh@suse.de>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.1.5
Message-ID: <20111212190526.GA12332@suse.de>
References: <20111209172316.GA24144@kroah.com>
 <CA+5PVA4N5Vu+9TjEsbVc=KW3q7kqEKQEME=pspP7OomQUX9dYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA4N5Vu+9TjEsbVc=KW3q7kqEKQEME=pspP7OomQUX9dYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 01:42:42PM -0500, Josh Boyer wrote:
> On Fri, Dec 9, 2011 at 12:23 PM, Greg KH <gregkh@suse.de> wrote:
> > I'm announcing the release of the 3.1.5 kernel.
> >
> > All users of the 3.1 kernel series must upgrade.
> 
> <snip>
> 
> > Thomas Poussevin (1):
> >      USB: EHCI: fix HUB TT scheduling issue with iso transfer
> 
> Hrm... this was added in 3.1.3, then reverted for 3.1.4 because it
> broke various devices:
> 
> http://thread.gmane.org/gmane.linux.kernel/1220960/focus=1221485
> 
> now it seems to be back in 3.1.5.  Was there another commit that was
> added to solve the other issues?

Yes, the one right after it.

thanks,

greg k-h
