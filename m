Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1DFV3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:29:23 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:54861 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab1DFV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:29:22 -0400
Date: Wed, 6 Apr 2011 22:26:11 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110406212611.GA5131@sucs.org>
References: <20110404211604.GB6133@sucs.org> <20110406130423.GE4142@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406130423.GE4142@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 06:04:23AM -0700, Tejun Heo wrote:
> I think disk_block_events was a bit too agressive with optimization.
> Can you please test the following patch and see whether the problem
> goes away?

With the 2.6.39-rc2 the warning has mysteriously disappeared all by
itself. Could it be that other parts of the kernel were causing this to
manifest itself?

-- 
Sitsofe | http://sucs.org/~sits/
