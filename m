Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab2ENX63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:58:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34168 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2ENX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:58:27 -0400
Date: Mon, 14 May 2012 16:58:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sage Ahn <syahn@gctsemi.com>
Cc: devel@driverdev.osuosl.org, olofj@chromium.org,
        linux-kernel@vger.kernel.org, benchan@chromium.org
Subject: Re: [PATCH] staging: gdm72xx: Add GCT GDM72xx WiMAX driver.
Message-ID: <20120514235823.GA21256@kroah.com>
References: <1337039376-15345-1-git-send-email-syahn@gctsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337039376-15345-1-git-send-email-syahn@gctsemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 08:49:36AM +0900, Sage Ahn wrote:
> This patch provides the kernel driver for the GDM72xx WiMAX chips
> developed by GCT Semiconductor, Inc., which enables mobile WiMAX
> connection on the Linux host.
> 
> Signed-off-by: Sage Ahn <syahn@gctsemi.com>
> Cc: Ben Chan <benchan@chromium.org>

Nice.

A few minor comments:

>  drivers/staging/gdm72xx/ChangeLog   |   88 +++

This file is not needed.

>  drivers/staging/gdm72xx/LICENSE     |   26 +

This file should not be needed either.

And that is where this gets wierd, your LICENSE file looks like a
BSD-like license:

> --- /dev/null
> +++ b/drivers/staging/gdm72xx/LICENSE
> @@ -0,0 +1,26 @@
> +Copyright (c) 2012, GCT Semiconductor, Inc. All rights reserved.
> +
> +Redistribution and use in source and binary forms, with or without
> +modification, are permitted provided that the following conditions are met:
> +    * Redistributions of source code must retain the above copyright
> +      notice, this list of conditions and the following disclaimer.
> +    * Redistributions in binary form must reproduce the above copyright
> +      notice, this list of conditions and the following disclaimer in the
> +      documentation and/or other materials provided with the distribution.
> +    * Neither the name of GCT Semiconductor, Inc. nor
> +      the names of its contributors may be used to endorse or promote
> +      products derived from this software without specific prior written
> +      permission.
> +
> +
> +THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
> +AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> +IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> +ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
> +LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> +CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> +SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
> +INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
> +CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> +ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> +POSSIBILITY OF SUCH DAMAGE.

And the code says:

> --- /dev/null
> +++ b/drivers/staging/gdm72xx/gdm_qos.c
> @@ -0,0 +1,453 @@
> +/*
> + * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
> + * Use of this source code is governed by a BSD-style license that can be
> + * found in the LICENSE file.
> + */

But then you say later on in the file:

> +MODULE_LICENSE("GPL");

Which seems to be a contradiction here, don't you agree?

Care to discuss this with your company's lawyers and let us know what
they say?

thanks,

greg k-h
