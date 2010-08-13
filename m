Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329Ab0HMDfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 23:35:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55929 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0HMDfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 23:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H8hAhXHP+iubAkn6BIfAs3jLJnw06BjfqQE/fbtpQbLAXDM0za8OSQzdCAFN811baZ
         jeSFX4b/gEl5DBoUFyFjUzHXSQg16UK9dtvhHXD7JRaQBN3brkR4KB1gK8Mjei33L4+M
         /TMn//BwHs62m4UGxmL7eyt9jUa471R9tKSvI=
Date: Thu, 12 Aug 2010 20:35:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100813033528.GD2661@core.coreip.homeip.net>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
 <20100524161527.GC3182@core.coreip.homeip.net>
 <20100616083903.GU17833@buzzloop.caiaq.de>
 <20100721083048.GA21558@core.coreip.homeip.net>
 <20100721083150.GB21558@core.coreip.homeip.net>
 <20100811070238.GF10432@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811070238.GF10432@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 09:02:38AM +0200, Daniel Mack wrote:
> Hi Dmitry,
> 
> On Wed, Jul 21, 2010 at 01:31:50AM -0700, Dmitry Torokhov wrote:
> > Input: switch to input_abs_*() access functions
> > 
> > From: Daniel Mack <daniel@caiaq.de>
> > 
> > Change all call sites in drivers/input to not access the ABS axis
> > information directly anymore. Make them use the access helpers instead.
> > 
> > Also use input_set_abs_params() when possible.
> > Did some code refactoring as I was on it.
> > 
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > Cc: Dmitry Torokhov <dtor@mail.ru>
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> 
> Hmm, there are three locations where some mysterious 'XX' characters
> were introduced.
> 

Gah, it is all my fault, I was marking stuff that I want to review but
missed these 2 drivers.

I sent it on to Linus, hopefully he'll apply it.

-- 
Dmitry
