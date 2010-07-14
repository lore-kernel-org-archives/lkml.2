Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0GNI0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 04:26:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51147 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0GNI0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 04:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sUBubm95iQawMauO3CIT6mJ/3nOL4WfycVhyGuqp4y8vjte6+XUw/XdrT3OR9tjD3x
         pb28NXtF8DHuu6CwRBIhi1wV6x3qp2wK0R8ZFB0jj5xoIvmqTnaLCfvy16N2NDOJDuei
         SFMfJXcMpvPd9wyg9EFkd5Uh3UkT8IQbblimo=
Date: Wed, 14 Jul 2010 01:20:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add pwm beeper driver
Message-ID: <20100714082057.GA2786@core.coreip.homeip.net>
References: <1279041459-5585-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279041459-5585-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 07:17:39PM +0200, Lars-Peter Clausen wrote:
> This patch adds a simple driver which allows to use pwm based beepers (for
> example piezo elements) as a pcspkr-like device.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

The driver looks reasonable, applied to 'next' branch, thanks
Lars-Peter.

-- 
Dmitry
