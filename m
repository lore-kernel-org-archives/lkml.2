Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0GKTjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 15:39:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:59268 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab0GKTjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 15:39:45 -0400
Date: Sun, 11 Jul 2010 21:39:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de
Subject: Re: [PATCH v3]kernel.h Move preprocessor #warning about using kernel
 headers in userpsace to types.h
In-Reply-To: <1278019707-30585-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1007112139140.4741@pobox.suse.cz>
References: <1278019707-30585-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Justin P. Mattock wrote:

> Move the preprocessor #warning message:
> warning: #warning Attempt to use kernel headers from user space, 
> see http://kernelnewbies.org/KernelHeaders
> from kernel.h to types.h.
> And also fixe the #warning message due to the preprocessor not being
> able to read the web address due to it thinking it was the start of a comment.
> also remove the extra #ifndef _KERNEL_ since it's already there.

I have applied the patch, thanks Justin for your persistence, and thanks 
for reviews while I have been offline, Arnd.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
