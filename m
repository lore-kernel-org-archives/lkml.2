Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1HFUBg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 16:01:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55682 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1HFUBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 16:01:35 -0400
Date: Sat, 6 Aug 2011 21:01:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ari Savolainen <ari.m.savolainen@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix POSIX ACL permission check
Message-ID: <20110806200133.GV2203@ZenIV.linux.org.uk>
References: <1312648987-4886-1-git-send-email-ari.m.savolainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312648987-4886-1-git-send-email-ari.m.savolainen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 07:43:07PM +0300, Ari Savolainen wrote:
> After commit 3567866bf261: "RCUify freeing acls, let check_acl() go ahead in
> RCU mode if acl is cached" posix_acl_permission is being called with an
> unsupported flag and the permission check fails. This patch fixes the issue.

Nice catch.  Applied...
