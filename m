Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1HWV7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:59:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60095 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1HWV7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:59:25 -0400
Date: Tue, 23 Aug 2011 22:59:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thieu Le <thieule@chromium.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Export do_fallocate() to kernel modules
Message-ID: <20110823215924.GN2203@ZenIV.linux.org.uk>
References: <1314136075-8784-1-git-send-email-thieule@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314136075-8784-1-git-send-email-thieule@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 02:47:55PM -0700, Thieu Le wrote:
> Export do_fallocate() so layered file systems such as ecryptfs can take
> advantage of this interface.  Existing interfaces to the fallocate
> facilities require a file descriptor which is not available to layered
> file systems.

Details, please.  do_fallocate() does shitloads of checks, probably pointless
for ecryptfs and its ilk, but I want to see users for that export before
I can say whether it's OK or not.
