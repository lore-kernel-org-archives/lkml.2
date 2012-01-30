Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab2A3KQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:16:14 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60774 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2A3KQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1201282026500.1973@hadrien>
References: <alpine.DEB.2.02.1201282026500.1973@hadrien>
Date: Mon, 30 Jan 2012 10:16:12 +0000
Message-ID: <CAPM=9twMwts87HLEKCMd68etvwyrS=rDxRcytCPU+7_7MonpZQ@mail.gmail.com>
Subject: Re: question about drivers/gpu/drm/drm_ioc32.c
From: Dave Airlie <airlied@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 7:28 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> In the function compat_drm_getclient, I have the impression that the
> structure c32 is copied to user level with the field idx uninitialized?

Looks like it alright,

care to send a patch?

Dave.
