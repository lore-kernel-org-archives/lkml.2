Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766Ab1KCPjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:39:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47188 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932244Ab1KCPjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:39:33 -0400
Date: Thu, 3 Nov 2011 11:39:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
In-Reply-To: <CAOS58YNNx7XOGov19_hucAQYvw88F2YO+KoVpn8uD+COgJRbEw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1111031139150.2136-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011, Tejun Heo wrote:

> Hello,
> 
> On Thu, Nov 3, 2011 at 7:37 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> >> Yes, it is a problem.  But it looks like the underlying issue is that
> >> you're using the SCSI error handler to do something it was not intended
> >> for.  Can't you suspend and resume the ATA port without using the error
> >> handler?
> >
> > The system suspend and resume of the ATA port uses the error handler.
> > I think the runtime suspend and resume should use the error handler too.
> >
> > Tejun,
> >
> > Could you comment more on this?
> 
> I don't know. I haven't really thought about it but as it's currently
> designed, I don't think it'll be possible to avoid going through EH to
> put ATA ports into suspend mode.

Why not?

Alan Stern

