Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0EIMGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 08:06:20 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:49750 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab0EIMGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 08:06:05 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 May 2010 08:06:03 EDT
Subject: Re: [PATCH] backlight: Add Cirrus EP93xx backlight driver
From: Richard Purdie <rpurdie@rpsys.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "ryan@bluewatersys.com" <ryan@bluewatersys.com>
In-Reply-To: <0D753D10438DA54287A00B0270842697636EC1EA58@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636EC1EA58@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 14:43:20 +0100
Message-ID: <1273326200.4312.36.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 12:13 -0500, H Hartley Sweeten wrote:
> The EP9307, EP9312, and EP9315 processors include a framebuffer
> peripheral.  This peripheral has a dedicated pwm output called
> BRIGHT that can be used to control the backlight on an LCD.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <ryan@bluewatersys.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>

Queued in the backlight tree, thanks.

Richard

