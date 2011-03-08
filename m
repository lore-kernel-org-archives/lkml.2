Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1CHN7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:59:30 -0500
Received: from kroah.org ([198.145.64.141]:58953 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab1CHN73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:59:29 -0500
Date: Tue, 8 Mar 2011 05:59:09 -0800
From: Greg KH <greg@kroah.com>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, kyungmin.park@samsung.com,
        Ben Dooks <ben-i2c@fluff.org>
Subject: Re: [PATCH v3] misc: adds support the FSA9480 USB Switch
Message-ID: <20110308135909.GA7519@kroah.com>
References: <4D75D338.9070801@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D75D338.9070801@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 03:56:56PM +0900, Minkyu Kang wrote:
> --- /dev/null
> +++ b/include/linux/fsa9480.h

Why do you need a .h file for this driver?

If it's just for platform data, please put it in
include/linux/platform_data/ instead.

If it's not, then please just move it to your driver's .c file.

thanks,

greg k-h
