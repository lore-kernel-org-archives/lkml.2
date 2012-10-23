Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965298Ab2JWUPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:15:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41477 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965273Ab2JWUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:15:42 -0400
Date: Tue, 23 Oct 2012 13:15:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 048/193] drivers/gpu/drm/udl: remove CONFIG_EXPERIMENTAL
Message-ID: <20121023201539.GD3408@kroah.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-49-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-49-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:02:01PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: David Airlie <airlied@linux.ie>
> CC: Dave Airlie <airlied@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/gpu/drm/udl/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

