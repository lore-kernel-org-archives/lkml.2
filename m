Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2FCN0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 09:26:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44788 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723Ab2FCN0w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 09:26:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAO6yer+0zUNFVGW8wO2mdSQodzzaw2WsRQHVmUAs1Xr_FHXx3Q@mail.gmail.com>
References: <1338720077-14936-1-git-send-email-corone.il.han@gmail.com>
	<CAO6yer+0zUNFVGW8wO2mdSQodzzaw2WsRQHVmUAs1Xr_FHXx3Q@mail.gmail.com>
Date: Sun, 3 Jun 2012 15:26:51 +0200
Message-ID: <CAFLxGvzQtrbrxY478J0bybAWftctBPMXmKOVgguxRHBPtaY_xA@mail.gmail.com>
Subject: Re: [PATCH] drm: An uninitialized return value is returned.
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: bing deng <deng8bing@gmail.com>
Cc: Il Han <corone.il.han@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 2:26 PM, bing deng <deng8bing@gmail.com> wrote:
> Hi All,
>
>    Why not modify "int ret;" to "int ret = 0;"? Below is the benefit:
>    1. return the constant 0 as wish.
>    2. The variable ret can be used if we want.

Why? ret is in vain and wastes memory...

-- 
Thanks,
//richard
