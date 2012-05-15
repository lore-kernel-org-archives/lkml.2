Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965861Ab2EOQhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:37:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49005 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2EOQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:37:39 -0400
Date: Tue, 15 May 2012 09:37:34 -0700
From: Tejun Heo <tejun@google.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 03/16] Revert "rw_semaphore: remove
 up/down_read_non_owner"
Message-ID: <20120515163734.GD17216@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <3f51ec3e69b8f471e2d1cc539f01504e2b903fed.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f51ec3e69b8f471e2d1cc539f01504e2b903fed.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:08:49PM -0400, Kent Overstreet wrote:
> This reverts commit 11b80f459adaf91a712f95e7734a17655a36bf30.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Please cc Christoph and Al and justify why it needs to be reverted.

Thanks.

-- 
tejun
