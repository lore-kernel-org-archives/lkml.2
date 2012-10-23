Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab2JWXeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:34:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57794 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587Ab2JWXeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:34:07 -0400
Date: Wed, 24 Oct 2012 00:33:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 007/193] arch/arm: remove CONFIG_EXPERIMENTAL
Message-ID: <20121023233356.GY21164@n2100.arm.linux.org.uk>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-8-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-8-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:01:20PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.

I have a patch queued up for -rc which removes a number of these, but
specifically leaves some which do cause people problems.  So I'd
appreciate it if we kept some of these (EXPERIMENTAL) tags even if we
do drop the dependency.
