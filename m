Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030741Ab2CSKvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:51:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55522 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030647Ab2CSKvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <1332113668-4364-4-git-send-email-daniel.vetter@ffwll.ch>
References: <1332113668-4364-1-git-send-email-daniel.vetter@ffwll.ch>
	<1332113668-4364-4-git-send-email-daniel.vetter@ffwll.ch>
Date: Mon, 19 Mar 2012 10:51:51 +0000
Message-ID: <CAPM=9twSZJyYcNwDwaC5eSy7fXNaRBGTZZ6F2K3D8AeQdYtgww@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 4/4] dma-buf: document fd flags and
 O_CLOEXEC requirement
From: Dave Airlie <airlied@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 11:34 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Otherwise subsystems will get this wrong and end up with and second
> export ioctl with the flag and O_CLOEXEC support added.

Its not actually dma_buf_export that takes the O_CLOEXEC flag its dma_buf_fd

I'm not sure how blindly we should be passing flags in from userspace
to these, like O_NONBLOCK or perms flags.

Dave.
