Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957Ab2KOWm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:42:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60918 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2KOWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:42:57 -0500
Date: Thu, 15 Nov 2012 14:42:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: drivres/hv
Message-ID: <20121115224253.GC16377@kroah.com>
References: <1351894283-12902-1-git-send-email-kys@microsoft.com>
 <20121102233717.GB3239@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF930E47FEC@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20121115143442.fd3672b8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115143442.fd3672b8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 02:34:42PM -0800, Andrew Morton wrote:
> On Thu, 15 Nov 2012 22:22:06 +0000
> KY Srinivasan <kys@microsoft.com> wrote:
> 
> > 
> > 
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Friday, November 02, 2012 7:37 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> > > Subject: Re: drivres/hv
> > > 
> > > On Fri, Nov 02, 2012 at 03:11:23PM -0700, K. Y. Srinivasan wrote:
> > > >
> > > > Greg,
> > > >
> > > > Recently, I had  re-sent a few patches. You have applied all the patches except
> > > the balloon driver
> > > > related patches. Should I resend the balloon driver  patches. Let me know.
> > > 
> > > I can't apply the balloon driver until you get an ack from the
> > > maintainers of the code you were exporting the symbols from.
> > > 
> > > Get that, and then resend them, as they are long gone from my "to-apply"
> > > queue.
> > 
> > Greg,
> > 
> > Andrew has checked in my patch that exports the necessary function for Hyper-V
> > balloon driver:
> > 
> > commit bb2495a71b8499bdfe207738bc88ffa91ebe0b0a
> > Author: K. Y. Srinivasan <kys@microsoft.com>
> > Date:   Thu Nov 15 13:37:59 2012 +1100
> > 
> > I had sent the new balloon driver that used this new function a few days ago. Should I
> > resend the balloon driver. Let me know.
> 
> I'll send this in to Linus later this week, to make life easier for
> everyone.  Or Greg can grab it.

I'll grab it.

thanks,

greg k-h
