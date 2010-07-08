Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab0GHWzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 18:55:50 -0400
Received: from tundra.namei.org ([65.99.196.166]:52623 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab0GHWzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 18:55:48 -0400
Date: Fri, 9 Jul 2010 08:55:42 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 18/18] vfs: make no_llseek the default
In-Reply-To: <201007082157.IFC26590.JMQSHOFFFOVLtO@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.00.1007090855160.23354@tundra.namei.org>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-19-git-send-email-arnd@arndb.de> <201007082025.HDB82385.OOVHQSLtFFMFJO@I-love.SAKURA.ne.jp> <201007081408.06415.arnd@arndb.de>
 <201007082157.IFC26590.JMQSHOFFFOVLtO@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010, Tetsuo Handa wrote:

> >From d0fdb09cdc8ef46151d330a9fc285de86306fa65 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Thu, 8 Jul 2010 21:38:05 +0900
> Subject: [PATCH] TOMOYO: Explicitly set file_operations->llseek pointer.
> 
> TOMOYO does not deal offset pointer. Thus seek operation makes
> no sense. Changing default seek operation from default_llseek()
> to no_llseek() might break some applications. Thus, explicitly
> set noop_llseek().
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
