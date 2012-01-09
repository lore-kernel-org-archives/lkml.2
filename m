Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2AIAXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:23:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:17729 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab2AIAXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:23:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="54503359"
Date: Mon, 9 Jan 2012 01:29:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: a.zummo@towertech.it, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, Kevin Liu <kliu5@marvell.com>
Subject: Re: [PATCH 2/3] misc: max8925_onkey: add function to work as wakeup
 source
Message-ID: <20120109002946.GJ13679@sortiz-mobl>
References: <1325661266-7982-1-git-send-email-haojian.zhuang@marvell.com>
 <1325661266-7982-2-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325661266-7982-2-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Wed, Jan 04, 2012 at 03:14:25PM +0800, Haojian Zhuang wrote:
> From: Kevin Liu <kliu5@marvell.com>

I got this build error:

  CC      drivers/input/misc/max8925_onkey.o
drivers/input/misc/max8925_onkey.c: In function ‘max8925_onkey_suspend’:
drivers/input/misc/max8925_onkey.c:169:30: error: ‘onkey_irq’ undeclared
(first use in this function)
drivers/input/misc/max8925_onkey.c:169:30: note: each undeclared identifier is
reported only once for each function it appears in
drivers/input/misc/max8925_onkey.c: In function ‘max8925_onkey_resume’:
drivers/input/misc/max8925_onkey.c:181:32: error: ‘onkey_irq’ undeclared
(first use in this function)
make[3]: *** [drivers/input/misc/max8925_onkey.o] Error 1
make[2]: *** [drivers/input/misc] Error 2
make[1]: *** [drivers/input] Error 2

So I put this one aside.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
