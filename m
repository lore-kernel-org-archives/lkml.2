Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1BUTgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:36:39 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47603 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab1BUTgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:36:38 -0500
Date: Mon, 21 Feb 2011 11:36:21 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: hide kernel addresses via %pK in /proc/<pid>/stack
Message-ID: <20110221193621.GO4000@outflux.net>
References: <20110221191121.5764.81241.stgit@localhost6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221191121.5764.81241.stgit@localhost6>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 10:11:21PM +0300, Konstantin Khlebnikov wrote:
> This file is readable for the task owner.
> Hide kernel addresses from unprivileged users,
> leave them function names and offsets.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Yes, please. :)

Acked-by: Kees Cook <kees.cook@canonical.com>

-- 
Kees Cook
Ubuntu Security Team
