Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1GWKEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 06:04:38 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:33531 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1GWKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 06:04:32 -0400
Date: Sat, 23 Jul 2011 12:04:25 +0200
From: Tejun Heo <tj@kernel.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        rtc-linux@googlegroups.com, osd-dev@open-osd.org,
        linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au,
        paulmck@linux.vnet.ibm.com, namhyung@gmail.com,
        randy.dunlap@oracle.com, cabarnes@indesign-llc.com,
        akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com,
        johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com,
        bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com,
        khali@linux-fr.org, airlied@linux.ie
Subject: Re: [PATCH 1/8] ida: Simplified functions for id allocation.
Message-ID: <20110723100425.GL21089@mtj.dyndns.org>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
 <1311352886-4047-11-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311352886-4047-11-git-send-email-jic23@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 05:41:19PM +0100, Jonathan Cameron wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> The current hyper-optimized functions are overkill if you simply want
> to allocate an id for a device.  Create versions which use an internal
> lock.
> 
> Thanks to Tejun for feedback.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Yeap, still looks good to me.

Thank you.

-- 
tejun
