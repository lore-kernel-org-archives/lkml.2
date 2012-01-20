Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2ATRbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:31:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41109 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2ATRbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:31:17 -0500
Date: Fri, 20 Jan 2012 09:31:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup: move struct cgroup_pidlist out from the
 header file
Message-ID: <20120120173111.GB3336@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F18E651.2000109@cn.fujitsu.com>
 <4F18E673.9070306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F18E673.9070306@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 11:58:43AM +0800, Li Zefan wrote:
> It's internally used only.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Both applied to cgroup/for-3.4.  Thanks!

-- 
tejun
