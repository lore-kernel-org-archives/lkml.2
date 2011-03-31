Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1CaFZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:25:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56220 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1CaFZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i2i8iRVWInpgxl9iLUAkCqqjCfzfpBl8+RXd0Jfd4kCr6t4w9BH57meL3/1btVWbPN
         INXJcKynA79IFG0Wh+ej/OpBlMawUiKQl2M9vgdRPNsmfUElrlWL85WhOiLr2IHAdYJ4
         9QskWdkiGbt3yCbvhqXLvrHpxdgvOS5YApBv8=
Date: Wed, 30 Mar 2011 22:25:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uinput: Allow for 0/0 min/max on absolute axes.
Message-ID: <20110331052526.GA31630@core.coreip.homeip.net>
References: <20110331050503.GA9318@barra.bne.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331050503.GA9318@barra.bne.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 03:05:03PM +1000, Peter Hutterer wrote:
> Some devices provide absolute axes with min/max of 0/0 (e.g. wacom's
> ABS_MISC axis). Current uinput restrictions do not allow duplication of
> these devices and require hacks in userspace to work around this.
> 
> If the kernel accepts physical devices with a min/max of 0/0, uinput
> shouldn't disallow the same range.
> 

Right, we should treat 0/0 as unlimited, or not specified, not
applicable.

Applied, thank you Peter.

-- 
Dmitry
