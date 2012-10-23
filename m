Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079Ab2JWUQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:16:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41477 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563Ab2JWUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:16:13 -0400
Date: Tue, 23 Oct 2012 13:16:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jiri Slaby <jslaby@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 099/193] drivers/net/wan: remove CONFIG_EXPERIMENTAL
Message-ID: <20121023201610.GF3408@kroah.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-100-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-100-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:02:52PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> CC: Jiri Slaby <jslaby@suse.cz>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Takashi Iwai <tiwai@suse.de>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/wan/Kconfig |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

