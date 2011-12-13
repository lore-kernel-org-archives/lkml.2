Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1LMPlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:41:18 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51618 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1LMPlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:41:16 -0500
Date: Tue, 13 Dec 2011 07:41:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3] make 'none' field a flag
Message-ID: <20111213154108.GF25802@google.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com>
 <1323614738-7405-5-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323614738-7405-5-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 03:45:38PM +0100, Glauber Costa wrote:
> There is no reason to have a flags field, and then a separate
> bool field just to indicate if 'none' subsystem were explicitly
> requested.
> 
> Make it a flag
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Same as the previous patch.  Doesn't this change how remount
conditions are checked?

Thanks.

-- 
tejun
