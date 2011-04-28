Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1D1G0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:26:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65197 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1D1G0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XX3ZRhB8qGpkenFgO5n3qInn7aQUkVhm2M0Nu3KVLDdNkDAFIXu8OMlpEi3g0ZbS0x
         Js52FfmiW6ybJbKiUF62iALqkAEH1Kpc9RHqWwHLLTLlLrVGQ8rLRlGY+RUSIIPf365L
         CTaroF8wHMWQkV1eJ2ZbaE0JcROOaB7xbIRq0=
Date: Wed, 27 Apr 2011 23:26:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Peter De Schrijver <peter.de-schrijver@nokia.com>,
        Felipe Balbi <felipe.balbi@nokia.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: twl4030-pwrbutton - fix a leak of the IRQ during
 init failure
Message-ID: <20110428062635.GE31734@core.coreip.homeip.net>
References: <1303963041.2588.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303963041.2588.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 11:57:21AM +0800, Axel Lin wrote:
> In twl4030_pwrbutton_probe error path, free_irq() was using NULL rather than
> the driver data as the data pointer so free_irq() wouldn't have matched.

Applied, thanks Axel.

-- 
Dmitry
