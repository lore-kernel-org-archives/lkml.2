Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab2IFU0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:26:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45629 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759658Ab2IFU0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:26:47 -0400
Date: Thu, 6 Sep 2012 13:26:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.7] workqueue: move gcwq_associate() under CPU
 hotplug section
Message-ID: <20120906202642.GL29092@google.com>
References: <20120906200948.GJ29092@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906200948.GJ29092@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Sep 06, 2012 at 01:09:48PM -0700, Tejun Heo wrote:
> From f3b57042feab077e340da166f0a0329793e94a16 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 6 Sep 2012 12:59:59 -0700
> 
> gcwq_associate() is now more involved with CPU hotplug and its current
> location requires forward declarations of
> gcwq_claim/release_management().  Move it under CPU hotplug section
> and remove the prototypes.
> 
> This patch is pure relocation.  Nothing else changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

This and the fixes have been pushed out to wq/for-3.7.  Please go
ahead and base cleanup / restructuring patches on top of it.

If you can make the hotplug path cleaner, that would be great but
please keep in mind that hotplug path being a bit messier is better
than contaminating the usual paths with considerations for hotplug.

Thanks.

-- 
tejun
