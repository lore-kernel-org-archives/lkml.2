Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab0HYJcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:32:07 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:41623 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751780Ab0HYJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:32:05 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX1+xsGFqTqix7GZJCyG5eGuADTNlVycDnoKwznI9L5
	gTbA3GTVG3zIhi
Subject: Re: [PATCH] drm/i915/tv: After disabling the pipe, use
 wait_for_vblank_off()
From: Ivan Bulatovic <combuster@gmx.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20100825081530.GB30504@sucs.org>
References: <1282647815.2221.15.camel@localhost.localdomain>
	 <1282662712-20493-1-git-send-email-chris@chris-wilson.co.uk>
	 <1282684130.2199.25.camel@localhost.localdomain>
	 <89k83a$9drtkt@azsmga001.ch.intel.com>
	 <1282691196.2120.30.camel@localhost.localdomain>
	 <20100825081530.GB30504@sucs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 11:31:59 +0200
Message-ID: <1282728719.2210.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 09:15 +0100, Sitsofe Wheeler wrote: 
> Does the patch in http://lkml.org/lkml/2010/8/24/280 change anything for
> you? If so I'm guessing we are seeing the same issue...
> 
> -- 
> Sitsofe | http://sucs.org/~sits/

No, that doesn't help, I still get TV connection detected. But the wait
for vblank timeout printks are gone as expected.

