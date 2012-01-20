Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2ATRYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:24:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40053 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2ATRYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:24:31 -0500
Date: Fri, 20 Jan 2012 09:24:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] percpu: use bitmap_clear
Message-ID: <20120120172425.GA3336@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 12:15:23AM +0900, Akinobu Mita wrote:
> Use bitmap_clear rather than clearing individual bits in a memory region.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>

Applied to percpu/for-3.4 w/ cl's ack added.

Thanks.

-- 
tejun
