Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161440Ab2JXW2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:28:32 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:56778 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161287Ab2JXW2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:28:31 -0400
Date: Thu, 25 Oct 2012 02:28:26 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 134/193] drivers/w1/masters: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024222826.GA27486@ioremap.net>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-135-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-135-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:03:27PM -0700, Kees Cook (keescook@chromium.org) wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Evgeniy Polyakov <zbr@ioremap.net>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Paul Walmsley <paul@pwsan.com>
> CC: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

I have no objections
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
