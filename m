Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0LIPuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:50:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:12816 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab0LIPuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:50:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="685522335"
Date: Thu, 9 Dec 2010 16:49:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, dmitry.torokhov@gmail.com,
        ben-linux@fluff.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/20] mfd/tc3589x: fix random interrupt misses
Message-ID: <20101209154956.GV8884@sortiz-mobl>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
 <1291388753-14662-12-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291388753-14662-12-git-send-email-sundar.iyer@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sundar,

On Fri, Dec 03, 2010 at 08:35:44PM +0530, Sundar Iyer wrote:
> On the TC35892, a random delayed interrupt clear (GPIO IC) write locks up the
> child interrupts. In such a case, the original interrupt is active and not yet
> acknowledged. Re-check the IRQST bit for any pending interrupts and handle
> those.

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

That does look like this patch should go into 2.6.37. Could you please
generate it against Linus tree and send it to me ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
