Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0HCAR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:17:28 -0400
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:47643 "EHLO
	smtp.towertech.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0HCAR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:17:27 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2010 20:17:27 EDT
Date: Tue, 3 Aug 2010 02:08:47 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        akpm@linux-foundation.org, p_gortmaker@yahoo.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com
Subject: Re: [PATCH v2 3/3] rtc: Add MAX8998 rtc driver
Message-ID: <20100803020847.58795fbd@linux.lan.towertech.it>
In-Reply-To: <1280734507-8398-3-git-send-email-jy0922.shim@samsung.com>
References: <1280734507-8398-1-git-send-email-jy0922.shim@samsung.com>
	<1280734507-8398-3-git-send-email-jy0922.shim@samsung.com>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010 16:35:07 +0900
Joonyoung Shim <jy0922.shim@samsung.com> wrote:

> This adds support for the RTC provided by the Maxim 8998 chip. This
> driver was tested on a GONI board by using the rtc-test application from
> the Documentation/rtc.txt.
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

 Seems nice. I'd add rtc_valid_tm where appropriate.
 And maybe free that irq you requested ;)

 pending those changes, you have my 

  Acked-by: Alessandro Zummo <a.zummo@towertech.it>


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

