Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0HCLXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:23:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49641 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab0HCLXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:cc:subject:x-mailer:references:in-reply-to
         :content-type:content-id:date:message-id:mime-version
         :content-transfer-encoding;
        b=RZkOl6KrpVOnCANvJUfXbeK6eS8HvWLG+2WIN9r+Jvf8oH9mL/nQBMyYuOub6lFjtw
         uTyrIKxs4vfteJfI9gj85PjFgUuIMxXQquoYliFMjm32ITJi96f/AEFQozS3pTYGXFVW
         0zDnMx0BV/+ioPL4n921inBEayii0WmdfsxDE=
From: Marek Vasut <marek.vasut.n900@gmail.com>
Reply-To: Marek Vasut <marek.vasut.n900@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] ucb1400_core: avoid calling platform_device_put()
	twice in ucb1400_core_probe error path
X-Mailer: Modest 3.2
References: <1280824453.19576.1.camel@mola>
	  <20100803103440.GE2635@sortiz-mobl>
In-Reply-To: <20100803103440.GE2635@sortiz-mobl>
Content-Type: text/plain; charset=utf-8
Content-ID: <1280834624.11842.5.camel@konomi>
Date: Tue, 03 Aug 2010 13:23:44 +0200
Message-Id: <1280834624.11842.6.camel@konomi>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Původní zpráva -----
> On Tue, Aug 03, 2010 at 04:34:13PM +0800, Axel Lin wrote:
> > In the case of goto err2, what we want is to call
> > platform_device_del() instead of platform_device_unregister().
> > Otherwise, we call platform_device_put() twice.
> Patch applied, thanks.
> 

Thanks guys, good catch!

Cheers
> Cheers,
> Samuel.
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/

