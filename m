Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1BXBLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 20:11:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56026 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1BXBLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 20:11:02 -0500
Date: Thu, 24 Feb 2011 01:10:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] Unlock vfsmount_lock in do_mount
Message-ID: <20110224011057.GP22723@ZenIV.linux.org.uk>
References: <1298447989-12107-1-git-send-email-hooanon05@yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298447989-12107-1-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 04:59:49PM +0900, J. R. Okajima wrote:
> By the commit
> 	b3e19d9 2011-01-07 fs: scale mntget/mntput
> vfsmount_lock was introduced around testing mnt_count.
> Fix the mis-typed 'unlock'

Gyah...  Nice catch.   Applied, will push tonight.
