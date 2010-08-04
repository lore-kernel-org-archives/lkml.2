Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0HDJNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:13:21 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:41503 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756207Ab0HDJNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:13:19 -0400
Date: Wed, 4 Aug 2010 11:13:17 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Message-ID: <20100804091317.GA27779@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	xfs@oss.sgi.com, linux-kernel@vger.kernel.org
References: <20100804073546.GA7494@comet.dominikbrodowski.net> <20100804085039.GA11671@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804085039.GA11671@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Wed, Aug 04, 2010 at 04:50:39AM -0400, Christoph Hellwig wrote:
> On Wed, Aug 04, 2010 at 09:35:46AM +0200, Dominik Brodowski wrote:
> > How can I best track down the cause of the performance problem, 
> > a) without rebooting too often, and
> > b) without breaking up the setup specified above (production system)?
> 
> So did you just upgrade the system from an earlier kernel that did not
> show these problems?

No, 2.6.31 to 2.6.34 show similar behaviour.

>  Or did no one notice them before?

Well, there are some reports relating to XFS on MD or RAID, though I couldn't
find a resolution to the issues reported, e.g.

- http://kerneltrap.org/mailarchive/linux-raid/2009/10/12/6490333
- http://lkml.indiana.edu/hypermail/linux/kernel/1006.1/00099.html

However, I think we can rule out barriers, as XFS is mounted "nobarrier"
here.

Best,
	Dominik
