Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab2ESPkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 11:40:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63938 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab2ESPku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 11:40:50 -0400
MIME-Version: 1.0
In-Reply-To: <4FB6F115.70703@xenotime.net>
References: <20120518184943.2c762e8441e53ea24748d1b8@canb.auug.org.au>
	<4FB6F115.70703@xenotime.net>
Date: Sat, 19 May 2012 16:40:50 +0100
Message-ID: <CAPM=9txuEJMv2Ttr+rEB0SFTnatB-hGNMNdKcmmNjXNyQfPfYg@mail.gmail.com>
Subject: Re: linux-next: Tree for May 18 (drm drivers and vgacon)
From: Dave Airlie <airlied@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 2:02 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 05/18/2012 01:49 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 201205017:
>
>
> When CONFIG_VGA_CONSOLE is not enabled:
>
> drivers/gpu/drm/cirrus/cirrus_drv.c:87:2: error: implicit declaration of function 'vgacon_text_force'
> drivers/gpu/drm/ast/ast_drv.c:224:2: error: implicit declaration of function 'vgacon_text_force'
> drivers/gpu/drm/mgag200/mgag200_drv.c:96:2: error: implicit declaration of function 'vgacon_text_force'

Thanks Randy,

fix pushed to drm-next.

Dave.
