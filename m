Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1I3QeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:34:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab1I3QeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:34:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Qiqstc6s+s0HOqnYwk6Juaz7grMKGZoF3i/xWfVASXZkpGzYEpZAgzdLgqn16K/X2
	h4lK9zNUvJK/ZB04ke3ig==
MIME-Version: 1.0
In-Reply-To: <20110930153321.GA31760@hmsreliant.think-freely.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1317307129-11579-1-git-send-email-nhorman@tuxdriver.com> <20110930143211.5ab39c02@stein>
 <20110930153321.GA31760@hmsreliant.think-freely.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 30 Sep 2011 10:33:36 -0600
Message-ID: <CAErSpo56QU78RHE0UOcvcT5iwcis1o_Ue=ZLPQ3GhdB483-L4Q@mail.gmail.com>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v4)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 9:33 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Fri, Sep 30, 2011 at 02:32:11PM +0200, Stefan Richter wrote:
> > On Sep 29 Neil Horman wrote:
> > > (v4)
> > > Fixed up some spelling mistakes, and added a scissors line with a good
> > > commitlog, so that git-am drops all the version logging
> > >
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > CC: Greg Kroah-Hartman <gregkh@suse.de>
> > > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > CC: Bjorn Helgaas <bhelgaas@google.com>
> > > CC: linux-pci@vger.kernel.org
> >
> > It drops these last 5 lines then too, doesn't it?
> >
> I would have thought so, but I tested a git-format-patch / git-am operation here
> on a temporary branch, and it worked properly.
>
> > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > @@ -66,6 +66,24 @@ Description:
> > >             re-discover previously removed devices.
> > >             Depends on CONFIG_HOTPLUG.
> > >
> > > +What:              /sys/bus/pci/devices/.../msi_irqs/
> > > +Date:              September, 2011
> > > +Contact:   Neil Horman <nhorman@tuxdriver.com>
> > > +Description:
> > > +           The /sys/devices/.../msi_irqs directory contains a variable set
> > > +           sub-directories, with each sub-directory being named after a
> > > +           corresponding msi irq vector allocated to that device.
> >
> > "contains a variable set _of_ sub-directories"?
> Gah, bad ispell foo on my part.  Bjorn, can you add that in, or shall I repost?

I'll try to remember to add that in.

Bjorn
