Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0JNKXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:23:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab0JNKXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:23:17 -0400
Date: Thu, 14 Oct 2010 12:22:17 +0200
From: Jan Kara <jack@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd: Check return value of __getblk()
Message-ID: <20101014102217.GB3482@quack.suse.cz>
References: <1286957838-5579-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286957838-5579-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-10-10 17:17:18, Namhyung Kim wrote:
> Fail journal creation if __getblk() returns NULL.  unlikely() is
> added because it is called in a loop and we've been OK without
> the check until now.
  Thanks. Merged.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
