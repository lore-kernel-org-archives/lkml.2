Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1ERFDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:03:11 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38735 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab1ERFDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:03:09 -0400
X-Sasl-enc: gIYq/TG2osYoQLbb/E+SI50/roR0Kwvp4qXex2UZ1zmO 1305694988
Date: Tue, 17 May 2011 22:03:26 -0700
From: Greg KH <greg@kroah.com>
To: anish singh <anish198519851985@gmail.com>
Cc: teddy.wang@siliconmotion.com.cn,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3][STAGING SM7XX-cleanup-resend]:removing extra
 spaces,redundant code and using macros
Message-ID: <20110518050326.GB24943@kroah.com>
References: <BANLkTi=d8EA8Z82rDqpL77iivKq-V1ix0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=d8EA8Z82rDqpL77iivKq-V1ix0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 08:41:32AM +0530, anish singh wrote:
> Hi Greg,
>  
> Resending all the 3 patches.
> Subject line:
> [PATCH 1/3][STAGING SM7XX-cleanup-resend]:removing extra spaces,redundant code
> and using macros
> [PATCH 2/3][STAGING SM7XX-cleanup-resend]:preferred form for passing a size to
> memory allocation routines
> [PATCH 3/3][STAGING SM7XX-cleanup-resend]:printk loglevels modified to match
> the scenario

This does not belong in the 1/3 patch, and neither does that extra
information in the [].

Your patches should look like:
	[PATCH 1/3] Staging: sm7xx: remove extra whitespace
and the like.

> This patch is to remove extra spaces,redundant code and using
>  ARRAY_SIZE macros.
>  Signed-off-by: anish kumar<anish198519851985@gmail.com>

You need an extra line before the Signed-off-by: line.

And an extra space after your name and before the '<'

Care to try it all again?

greg k-h
