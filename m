Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1AQIa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:30:27 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54145 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1AQIaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:30:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RUDEiElg2jeC1xqP6u8YGLVejCfA+8mFQwaLd7OXglRFHW3rvapfQJ/+ZcWL1SxW93
         8E5f5Cbu0xgysOrtWsSuT1AnJmCpD4QAx/rtyhFnIWvwXxtNONgMx+83NJePrAGCyvpO
         in0Xu8sJpaPlER9pCZM9qMKGyQt3soW16Pkko=
Date: Mon, 17 Jan 2011 00:22:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] input: ct82710c: return proper error code for
 ct82c710_open
Message-ID: <20110117082251.GB22802@core.coreip.homeip.net>
References: <1294940150.2200.4.camel@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294940150.2200.4.camel@offworld>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 02:35:50PM -0300, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> If request_irq() fails we should return the proper error instead of -1.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Will apply, thank you. You don't really have the device, do you?

Thanks.

-- 
Dmitry
