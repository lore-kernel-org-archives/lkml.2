Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1AVBvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:51:38 -0500
Received: from void.printf.net ([89.145.121.20]:54631 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab1AVBvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:51:37 -0500
Date: Sat, 22 Jan 2011 01:51:32 +0000
From: Chris Ball <cjb@laptop.org>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v4 1/1]mmc: implemented eMMC4.4 enhanced area feature
Message-ID: <20110122015132.GA6748@void.printf.net>
References: <20110121200941.GA16236@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121200941.GA16236@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuanxiao,

On Sat, Jan 22, 2011 at 04:09:41AM +0800, Chuanxiao Dong wrote:
> Enhanced area feature is a new feature defined in eMMC4.4 standard. This
> kind of area can help to improve the performance.
> 
> MMC driver will read out the enhanced area offset and size and add them
> to be device attributes. The feature enabling should be done in manufactory.
> To use this feature, bit ERASE_GRP_DEF should also be set.
> 
> Documentation/ABI/testing/sysfs-devices-mmc described the two new attributes
> 
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>

Looks good, pushed to mmc-next.  Thanks for all the edits to this!

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
