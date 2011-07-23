Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1GWKR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 06:17:29 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50265 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1GWKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 06:17:21 -0400
Date: Sat, 23 Jul 2011 12:17:14 +0200
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
Subject: Re: [PATCH 8/8] rtc: class idr converted to ida and ida_simple_get
 used.
Message-ID: <20110723101714.GM21089@mtj.dyndns.org>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
 <1311352886-4047-9-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311352886-4047-9-git-send-email-jic23@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 05:41:17PM +0100, Jonathan Cameron wrote:
> This is the one use of an ida that doesn't retry on receiving -EAGAIN.
> I'm assuming do so will cause no harm and may help on a rare occasion.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

And all conversions seem correct to me.  Please feel free to add

Reviewed-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
