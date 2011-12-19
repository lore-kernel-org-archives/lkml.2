Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1LSRPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:15:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36691 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1LSRPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:15:41 -0500
Date: Mon, 19 Dec 2011 09:15:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH] cgroups: remove redundant get/put of css_set from
 css_set_check_fetched()
Message-ID: <20111219171533.GH24519@google.com>
References: <1323987686-17968-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323987686-17968-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 02:21:26PM -0800, Mandeep Singh Baines wrote:
> We already have a reference to all elements in newcg_list.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: Paul Menage <paul@paulmenage.org>

Applied to for-3.3.  Thanks.

-- 
tejun
