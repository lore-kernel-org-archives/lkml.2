Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2KCOnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 10:43:52 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:55624 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2KCOnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:43:50 -0400
Date: Sat, 3 Nov 2012 07:43:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 0/4] 3.0.51-stable review
Message-ID: <20121103144340.GA1383@kroah.com>
References: <20121102170333.581931288@linuxfoundation.org>
 <20121103003108.GA1981@optiplex.redhat.com>
 <20121103040711.GD1602@kroah.com>
 <20121103114501.GA1688@optiplex.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103114501.GA1688@optiplex.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 09:45:02AM -0200, Rafael Aquini wrote:
> On Fri, Nov 02, 2012 at 09:07:11PM -0700, Greg Kroah-Hartman wrote:
> > > 
> > > Howdy Greg,
> > > 
> > > Somehow the following patch is missing for this series submission:
> > > > Len Brown <len.brown@intel.com>
> > > >     x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility
> > > 
> > > I glanced at the the downloadable consolidated patch and its hunks seem to be present,
> > > though.
> > 
> > I do not understand.  Where do you not see it?  It's in the patch on
> > kernel.org, right?  Where is it missing?
> > 
> 
> The LKML patch series is missing PATCH 02/04.

Odd, I received a copy, but I don't know if it came from lkml or as a
copy sent to me directly.  I'll bounce it to you if you are curious
about it.

greg k-h
