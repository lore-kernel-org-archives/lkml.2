Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab0HNQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 12:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab0HNQQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 12:16:25 -0400
Date: Sat, 14 Aug 2010 17:16:17 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com
Subject: Re: [dm-devel] linux-2.6.35+ causes LVM to fail with "
	device-mapper: version ioctl failed: Inappropriate ioctl for device"
Message-ID: <20100814161617.GK26032@agk-dp.fab.redhat.com>
Mail-Followup-To: Jeff Chua <jeff.chua.linux@gmail.com>,
	device-mapper development <dm-devel@redhat.com>,
	lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com> <20100814155401.GJ26032@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100814155401.GJ26032@agk-dp.fab.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 04:54:01PM +0100, Alasdair G Kergon wrote:
> The only one there possibly relevant is 7e507eb6432afdd798d4c6dccf949b8c43ef151c.

I'm guessing you could have a configuration not covered by the latest userspace
libdevmapper - not handling some combination of kernel+userspace+initrd packages
correctly.  We already dealt with one udev+initrd combination that failed last
week.
 
Alasdair

