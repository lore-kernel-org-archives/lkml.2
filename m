Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2KAHux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:50:53 -0400
Received: from 1wt.eu ([62.212.114.60]:34732 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2KAHuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:50:51 -0400
Date: Thu, 1 Nov 2012 08:50:29 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC/PATCH 2.6.32.y 0/3] Re: [stable 2.6.32..2.6.34] x86, ioapic: initialize nr_ioapic_registers early in mp_register_ioapic()
Message-ID: <20121101075029.GA23497@1wt.eu>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com> <20121024182546.GB3338@elie.Belkin> <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com> <20121024194114.GC3120@elie.Belkin> <1351117470.6017.91.camel@sbsiddha-desk.sc.intel.com> <20121024223100.GB6922@elie.Belkin> <87txtjqr5r.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txtjqr5r.fsf@xmission.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 06:25:20PM -0700, Eric W. Biederman wrote:
> Jonathan Nieder <jrnieder@gmail.com> writes:
> 
> > Suresh Siddha wrote:
> >
> >>                               Here is the updated patch with just some
> >> more text added to the changelog.
> >
> > Yes, that's clearer.  For what it's worth,
> > Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
> >
> > Thanks for your patience.
> 
> The strange days when code cleanups get backported as bug fixes.
> Just this minimal version of things look good.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Just queued it for 2.6.32, thanks guys.

Willy

