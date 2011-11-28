Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1K1MTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:19:39 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33305 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab1K1MTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:19:38 -0500
Date: Mon, 28 Nov 2011 05:19:37 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Max Kellermann <mk@cm4all.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/namei: waiting for mutex during name lookups is
	"killable"
Message-ID: <20111128121936.GR4387@parisc-linux.org>
References: <20111128113918.23050.25938.stgit@rabbit.intern.cm-ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128113918.23050.25938.stgit@rabbit.intern.cm-ag>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 12:39:18PM +0100, Max Kellermann wrote:
> Use mutex_lock_killable() instead of mutex_lock() during name lookups,
> to allow killing the process while it's waiting.

This is cool.  Could you describe what situations this mutex gets held
for a user-noticable length of time, and how you tested this patch?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
