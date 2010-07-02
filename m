Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0GBHFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:05:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:47156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab0GBHFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:05:39 -0400
Message-ID: <4C2D8FAD.7010704@kernel.org>
Date: Fri, 02 Jul 2010 09:05:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] dmi-id: fix a memory leak in dmi_id_init error path
References: <1277951707.30073.5.camel@mola>
In-Reply-To: <1277951707.30073.5.camel@mola>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Jul 2010 07:05:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/01/2010 04:35 AM, Axel Lin wrote:
> This patch adds a missing kfree(dmi_dev) in dmi_id_init error path.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Greg, can you please route this through device tree?

Thanks.

-- 
tejun
