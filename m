Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab2JWURG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:17:06 -0400
Received: from relay3.sgi.com ([192.48.152.1]:48678 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933546Ab2JWUQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:16:06 -0400
Date: Tue, 23 Oct 2012 15:16:04 -0500
From: Ben Myers <bpm@sgi.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH 154/193] fs/xfs: remove CONFIG_EXPERIMENTAL
Message-ID: <20121023201604.GB23915@sgi.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-155-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-155-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:03:47PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Ben Myers <bpm@sgi.com>
> CC: Alex Elder <elder@kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Ben Myers <bpm@sgi.com>
