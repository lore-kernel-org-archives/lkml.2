Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2JWVrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:47:25 -0400
Received: from cobra.newdream.net ([66.33.216.30]:42587 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab2JWVrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:47:22 -0400
Date: Tue, 23 Oct 2012 14:47:21 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 143/193] fs/ceph: remove CONFIG_EXPERIMENTAL
In-Reply-To: <1351022666-6960-144-git-send-email-keescook@chromium.org>
Message-ID: <alpine.DEB.2.00.1210231447090.6264@cobra.newdream.net>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-144-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Sage Weil <sage@inktank.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Sage Weil <sage@inktank.com>
