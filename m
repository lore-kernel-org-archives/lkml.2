Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0DUE7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 00:59:43 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:49352 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0DUE7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 00:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R6OXXP43eCViz0Hx3/beqLCCvviMQcB9x9gFadXbHpAY+cvmKFWh3dDBKOlUGe1xDF
         1XXxt6LzDr6MXg0h5U0BSWNQiodlrGDQByMTdmaI7h971n5iwVp9xllOeP5kPkhqUKnj
         eE/xinDfDy1zuVlhk0SNrJS5sr+u2KzXzY0Xw=
Date: Tue, 20 Apr 2010 21:59:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Edouard TISSERANT <edouard.tisserant@wanadoo.fr>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] acecad: fix incorrect size parameter in usb_buffer_free
Message-ID: <20100421045936.GA4364@core.coreip.homeip.net>
References: <m2i427d64721004201807z2888dd31oc1c54b61fb2d8078@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2i427d64721004201807z2888dd31oc1c54b61fb2d8078@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Apr 21, 2010 at 09:07:14AM +0800, Axel Lin wrote:
> The size allocated by usb_buffer_alloc is 8, however the size free by
> usb_buffer_free in usb_acecad_disconnect is 10.
> This patch corrects the size parameter in usb_buffer_free.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Greg KH <gregkh@suse.de>

Will apply both patches to 'next' (while size is wrong 8 and 10 still fall
in the same bucket so there shoudl not be any adverse effects apparent
to users).

You don't actually have the hardware by any chance?

-- 
Dmitry

P.S. Your mailer line-wraps patches so they have to be edited by hand
before applying, please look into it.
