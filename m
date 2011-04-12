Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab1DLQGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:06:36 -0400
Received: from verein.lst.de ([213.95.11.211]:35911 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758070Ab1DLQGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:06:34 -0400
Date: Tue, 12 Apr 2011 18:06:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Huge XFS regression in 2.6.32 upto 2.6.38
Message-ID: <20110412160633.GA3427@lst.de>
References: <1302594748.2750.11.camel@raz.scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302594748.2750.11.camel@raz.scalemp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 10:52:28AM +0300, raz ben yehuda wrote:
> Christoph Hello
> I am testing 2.6.38 with AIM benchmark. 
> I compared 2.6.38 to 2.6.27 and I noticed that 2.6.27 is much better than 2.6.38 when 
> doing sync random writes test over an xfs regular file over native Linux partition on top common sata disk.

As Dave already mentioned in your double post of this mail this is
because data now actually is forced out to disk in all cases,
while you previously hit a bug in the O_SYNC implementation.

