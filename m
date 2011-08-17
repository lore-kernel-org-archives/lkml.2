Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1HQKyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:54:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:49963 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab1HQKyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:54:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,239,1312182000"; 
   d="scan'208";a="39370327"
Subject: Re: [PATCH] Media controller: Define media_entity_init() and
 media_entity_cleanup() conditionally
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Deepthy Ravi <deepthy.ravi@ti.com>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Vaibhav Hiremath <hvaibhav@ti.com>
In-Reply-To: <1313577276-18182-1-git-send-email-deepthy.ravi@ti.com>
References: <1313577276-18182-1-git-send-email-deepthy.ravi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: Intel Finland Oy
Date: Wed, 17 Aug 2011 13:53:46 +0300
Message-ID: <1313578426.25065.1.camel@smile>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 16:04 +0530, Deepthy Ravi wrote: 
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Defines the two functions only when CONFIG_MEDIA_CONTROLLER
> is enabled.
Is it not a driver's option to be dependent on MEDIA_CONTROLLER?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
