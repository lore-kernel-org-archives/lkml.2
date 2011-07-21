Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1GUQmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:42:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1GUQmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:42:31 -0400
Date: Thu, 21 Jul 2011 09:31:48 -0700
From: Greg KH <gregkh@suse.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Milan Broz <mbroz@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHES] improve sysfs performance, make it O(log n)
Message-ID: <20110721163148.GA31647@suse.de>
References: <Pine.LNX.4.64.1107201836310.4812@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1107201836310.4812@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 06:56:50PM -0400, Mikulas Patocka wrote:
> Hi
> 
> Here are 5 patches to make sysfs O(log n) and improve performance on 
> operations with many block devices.

Very nice job.

But can you please resend these, one per email, so that they could be
applied to the tree (Documentation/SubmittingPatches describes this
requirement).

Also note that it is past the merge window time for patches to be
accepted for 3.1, so this will remain in my "to-apply" queue until after
3.1-rc1 is out for the 3.2 merge.

thanks,

greg k-h
