Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758Ab2AKUik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:38:40 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48976 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006Ab2AKUii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:38:38 -0500
Date: Wed, 11 Jan 2012 12:38:37 -0800
From: Kees Cook <keescook@chromium.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, tyler.hicks@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ecryptfs: Print inode on metadata error
Message-ID: <20120111203837.GS2618@outflux.net>
References: <1326301242-5817-1-git-send-email-tim.gardner@canonical.com>
 <1326301242-5817-3-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326301242-5817-3-git-send-email-tim.gardner@canonical.com>
Organization: Chromium
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 06:00:42PM +0100, Tim Gardner wrote:
> If a lower file system file is corrupted, then ecryptfs prints
> a generic and mostly useless log message when attempting to
> read metadata. Print the inode associated with the file
> so that a user can do something about it, e.g.,
> 
> find -inum INODE_NUM
> 
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: Tyler Hicks <tyler.hicks@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
