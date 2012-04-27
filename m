Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab2D0P0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:26:43 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34210 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760484Ab2D0P0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:26:40 -0400
Date: Fri, 27 Apr 2012 17:26:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hakan Akkan <hakanakkan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nohz/cpuset: enable addition&removal of cpus while in
 adaptive nohz mode
Message-ID: <20120427152632.GD3514@somewhere.redhat.com>
References: <4F99854E.80102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F99854E.80102@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 11:26:38AM -0600, Hakan Akkan wrote:
> Currently modifying cpuset.cpus mask of a cgroup does not
> update the reference counters for adaptive nohz mode if the
> cpuset already had cpuset.adaptive_nohz == 1. Fix it so that
> cpus can be added or removed from a adaptive_nohz cpuset.
> 
> Apply to Frederic's nohz/cpuset-v2 kernel 3.3.0-rc7nohz/cpuset-v2+
> (commit abd48ecb412ff023582e97442a02a7cb162a1c4e)
> 
> Signed-off-by: Hakan Akkan <hakanakkan@gmail.com>

It was in my TODO list, thanks a lot for fixing this!

The patch looks very nice. I'll test it and apply to my tree if it passes
basic testing.
