Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab0JGQRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:17:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53941 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0JGQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:17:53 -0400
Date: Thu, 7 Oct 2010 18:17:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, fweisbec@gmail.com,
        robert.richter@amd.com, gorcunov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
Message-ID: <20101007161748.GD6270@basil.fritz.box>
References: <20101007030807.GA4076@redhat.com>
 <20101007072641.GE5010@basil.fritz.box>
 <20101007140112.GN10663@redhat.com>
 <20101007151128.GC6270@basil.fritz.box>
 <20101007154758.GA22385@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007154758.GA22385@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 11:47:58AM -0400, Don Zickus wrote:
> > > No I prefer a single one too, but there didn't seem to be a
> > > send_IPI_self() command, so I took the short route and sent it to
> > > everyone. :-(
> > 
> > You're not sending it to everyone, everyone but you.
> > 
> > Anyways for standard APIC send_IPI_cpu should be easy enough
> > to add. Standard NMI is usually to CPU #0 only.
> 
> Would that still be x86 specific though?  I could probably code that up,
> though I wonder if it would be accepted just for a test case.

The whole APIC interface is x86 specific.

"just a test case" is the wrong perspective.
Testing is important, if a feature is not tested it likely won't
work. That's especially important for anything error handling related.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
