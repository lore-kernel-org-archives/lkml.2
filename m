Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1AaTR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:17:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38345 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab1AaTR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:17:28 -0500
Date: Mon, 31 Jan 2011 14:17:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: david@lang.hm, Stan Hoeppner <stan@hardwarefreak.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>,
        Mark Lord <kernel@teksavvy.com>
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110131191720.GA2327@infradead.org>
References: <4D419765.4070805@teksavvy.com>
 <4D41CA16.8070001@hardwarefreak.com>
 <alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
 <4D42056E.2050505@hardwarefreak.com>
 <alpine.DEB.2.00.1101271730030.17579@asgard.lang.hm>
 <20110128135629.GX21311@dastard>
 <alpine.DEB.2.00.1101281119250.17579@asgard.lang.hm>
 <20110129054021.GB21311@dastard>
 <alpine.DEB.2.00.1101282201260.29659@asgard.lang.hm>
 <20110129073554.GC21311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110129073554.GC21311@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 29, 2011 at 06:35:54PM +1100, Dave Chinner wrote:
> Just because we can't do it right now doesn't mean it is not
> possible. Array/raid controller vendors need to implement the SCSI
> block limit VPD page, and if they do then stripe unit/stripe width
> may be exposed for the device in sysfs. However, I haven't seen any
> devices except for md and dm that actually export values that
> reflect sunit/swidth in the files:

I have access to a few big vendor arrays that export it, but I think
they are still running beta firmware versions.

