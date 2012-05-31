Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab2EaO2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:28:15 -0400
Received: from 1wt.eu ([62.212.114.60]:2658 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab2EaO2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:28:14 -0400
Date: Thu, 31 May 2012 16:28:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: Mike Galbraith <efault@gmx.de>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] [2.6.32-longterm] ioat2: kill pending flag
Message-ID: <20120531142801.GL5321@1wt.eu>
References: <1338472815.7460.70.camel@marge.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338472815.7460.70.camel@marge.simpson.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, May 31, 2012 at 04:00:15PM +0200, Mike Galbraith wrote:
> Greetings,
> 
> While testing tbench 40 throughput on a 40 core (+SMT) Intel SDV S3E37,
> I found spin_lock_bh() consuming _90%_ of the box, driving throughput
> straight through the floor.  The commit below fixed it up.
> 
> This looks horrific enough to me to qualify for 2.6.32-longterm.

I've queued it up for next release. Thank you very much!

Willy

