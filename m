Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654Ab1FBI23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 04:28:29 -0400
Received: from linux-sh.org ([111.68.239.195]:58620 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759573Ab1FBI21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 04:28:27 -0400
Date: Thu, 2 Jun 2011 17:26:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Joe Perches <joe@perches.com>
Cc: Heiko St?bner <heiko@sntech.de>, Jaya Kumar <jayalk@intworks.biz>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jiri Kosina <trivial@kernel.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [TRIVIAL PATCH V2 next 12/15] video: Convert vmalloc/memset to vzalloc
Message-ID: <20110602082628.GI6087@linux-sh.org>
References: <cover.1306603968.git.joe@perches.com> <77538de911b8af99f68b7bcfbaaedce8e40db04f.1306603968.git.joe@perches.com> <201105281948.12941.heiko@sntech.de> <1306606413.20336.9.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306606413.20336.9.camel@Joe-Laptop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 11:13:33AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> Heiko St??bner <heiko@sntech.de> pointed out I can't type...
> s/vmalloc/vmalloc/ doesn't do much.
> 
>  drivers/video/arcfb.c        |    5 ++---
>  drivers/video/broadsheetfb.c |    4 +---
>  drivers/video/hecubafb.c     |    5 ++---
>  drivers/video/metronomefb.c  |    4 +---
>  drivers/video/xen-fbfront.c  |    3 +--
>  5 files changed, 7 insertions(+), 14 deletions(-)
> 
v2 applied.
