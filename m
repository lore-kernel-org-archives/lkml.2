Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1DIJe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 05:34:57 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:40293 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1DIJe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 05:34:56 -0400
Date: Sat, 9 Apr 2011 10:34:49 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110409093449.GA10016@sucs.org>
References: <20110404211604.GB6133@sucs.org> <20110406130423.GE4142@mtj.dyndns.org> <20110406212611.GA5131@sucs.org> <20110406213718.GA14139@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406213718.GA14139@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 02:37:18PM -0700, Tejun Heo wrote:
> 
> The problem would be quite timing dependent.  It would be great if you
> can prepare a setup where you can reproduce the problem on some
> regular basis and make sure that the problem goes away with the patch
> applied.

Try as I might I cannot even reproduce the problem with the original
problem kernels. I've tried all sorts (such as plugging in multiple USB
disks and killing/restarting services such as udisks) but the problem
has refused to show itself again. Originally I saw the message three
times over a two days period and two of those were within 10 seconds of
boot. I've booted the same kernel a dozen times but the error never
comes back...

-- 
Sitsofe | http://sucs.org/~sits/
