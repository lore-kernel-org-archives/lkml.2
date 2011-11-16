Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1KPT4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:56:46 -0500
Received: from peace.netnation.com ([204.174.223.2]:52874 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1KPT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:56:45 -0500
Date: Wed, 16 Nov 2011 11:56:43 -0800
From: Simon Kirby <sim@hostway.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111116195643.GF24411@hostway.ca>
References: <20111020224214.GC22772@hostway.ca> <20111021132240.GA24136@infradead.org> <20111021202857.GB30100@hostway.ca> <20111024082219.GA19941@infradead.org> <20111025200748.GA25043@hostway.ca> <20111026112521.GA10432@infradead.org> <20111104210324.GB14983@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104210324.GB14983@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 05:03:24PM -0400, Christoph Hellwig wrote:

> Sorry Simon,
> 
> I haven't really been able to get back to this as fast as I wanted to
> do.  Can you do another run and check if the patch still helps your
> issue even if you remove the xfs_log_force line?

Hello!

Sorry for the delay in testing.

Yes, everything looks fine even with the xfs_log_force line from your
patch commented out. So, the changes in xfs_reclaim_inode() are just the
set_bit(XBT_FORCE_FLUSH) and wake_up_process(), relative to 3.1.

Simon-
