Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1A1PpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:45:03 -0500
Received: from mail.perches.com ([173.55.12.10]:3470 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1A1PpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:45:02 -0500
Subject: Re: [PATCH 12/15] staging: ath6kl: Convert A_UINT8 is_amsdu and
 is_acl_data_frame to A_BOOL
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Vipin Mehta <vmehta@atheros.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110128114214.GD20606@bicker>
References: <cover.1296186677.git.joe@perches.com>
	 <3a5cf32b0de8cd3153d385e2198d7aa4c787697e.1296186677.git.joe@perches.com>
	 <20110128114214.GD20606@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 07:45:00 -0800
Message-ID: <1296229500.2448.229.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 14:42 +0300, Dan Carpenter wrote:
> On Thu, Jan 27, 2011 at 08:04:29PM -0800, Joe Perches wrote:
> > -                A_UINT8 is_amsdu, tid, is_acl_data_frame;
> > +                A_BOOL is_amsdu;
> > +                A_UINT8 tid;
> > +                A_BOOL is_acl_data_frame;
> 
> Just use bool for bool and u8 for u8.  It's not reasonable for everyone
> to rename basic types for every driver.  (Unless Atheros bool really is
> different from other people's bool then it would be totally reasonable).

That's a whole set of later patches.
No worries, they're coming.
At this point, doing a straight rename causes some defects.


