Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1HRJDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 05:03:50 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:49586 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1HRJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 05:03:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] Media controller: Define media_entity_init() and media_entity_cleanup() conditionally
Date: Thu, 18 Aug 2011 11:03:49 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: Deepthy Ravi <deepthy.ravi@ti.com>, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Vaibhav Hiremath <hvaibhav@ti.com>
References: <1313577276-18182-1-git-send-email-deepthy.ravi@ti.com> <1313578426.25065.1.camel@smile>
In-Reply-To: <1313578426.25065.1.camel@smile>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108181103.49805.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 12:53:46 Andy Shevchenko wrote:
> On Wed, 2011-08-17 at 16:04 +0530, Deepthy Ravi wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> > 
> > Defines the two functions only when CONFIG_MEDIA_CONTROLLER
> > is enabled.
> 
> Is it not a driver's option to be dependent on MEDIA_CONTROLLER?

Yes it is.

-- 
Regards,

Laurent Pinchart
