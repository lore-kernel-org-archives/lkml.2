Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2KUH5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:57:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2KUH5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:57:04 -0500
Date: Tue, 20 Nov 2012 23:56:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Bill Pemberton <wfp5p@virginia.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
Message-Id: <20121120235659.95001487.akpm@linux-foundation.org>
In-Reply-To: <CACxGe6ss3HsnGgNn=aOJsd0-6q-dRumPvkKdqjKWCFja9QDgtQ@mail.gmail.com>
References: <1353112043-11800-1-git-send-email-wfp5p@virginia.edu>
	<CACxGe6ss3HsnGgNn=aOJsd0-6q-dRumPvkKdqjKWCFja9QDgtQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 10:46:11 +0000 Grant Likely <grant.likely@secretlab.ca> wrote:

> On Sat, Nov 17, 2012 at 12:19 AM, Bill Pemberton <wfp5p@virginia.edu> wrote:
> > CONFIG_HOTPLUG is no longer an optional setting.  In order to remove
> > it as on option code paths that check CONFIG_HOTPLUG will removed
> > along with the attributes __devexit_p, __devexit, __devinitconst, and
> > __devinitdata.
> >
> > I'll save the list from the mailbomb of this huge patchset.  The
> > patches themselves are going to Greg KH for the driver core tree.
> >
> >
> > Bill Pemberton (493):
> [...]
> >  2942 files changed, 11645 insertions(+), 12116 deletions(-)
> 
> So, I've got no problem with the reason for the change and I don't
> even think you need my ack for the bits that I maintain (though you
> have it if you want it). However, this looks like it is going to be
> /painful/. First of all it will touch a huge number of files in the
> tree. Yes the change is trivial, but it will require manual fixups on
> a lot of patches.

Yeah, this is dopey.  Send the script to Linus and ask him to run it
seven seconds before he releases -rc1, when everyone's trees are
empty(ish).  Or send him a single megapatch at that time.
