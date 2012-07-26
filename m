Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab2GZGxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 02:53:44 -0400
Received: from mail.nonattached.net ([193.160.39.60]:41568 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2GZGxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 02:53:43 -0400
Subject: Re: [PATCH] scripts/kernel-doc: added support for html5
From: Dan Luedtke <mail@danrl.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <50103793.8000600@xenotime.net>
References: <1343223488-1332-1-git-send-email-mail@danrl.de>
	 <50103793.8000600@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Jul 2012 08:53:35 +0200
Message-ID: <1343285615.12424.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 11:14 -0700, Randy Dunlap wrote:
> Just say "html5" or "html version 5".
> A few years from now it won't be modern.
Haven't thought of that. Will be changed, thanks!

> Have you tested typedef, enum, DOC:, etc.?
Yes, here are a few examples:

DOC:
https://www.nonattached.net/lanyfs/doc-linux.php#doc:LanyFS_Inode_Cache

Typedef:
https://www.nonattached.net/lanyfs/doc-linux.php#typedef:lanyfs_blk_t
(You were right, it wasn't there yesterday, sorry!)

Enum:
https://www.nonattached.net/lanyfs/doc-fsutils.php#enum:mklanyfs_time
(It is a userspace tool, but it uses kernel-doc format)

I'll send the patches out in a minute.

Thanks!

Dan

-- 
Dan Luedtke
http://www.danrl.de

