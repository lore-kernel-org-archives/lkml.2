Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0CRRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:25:29 -0400
Received: from c60.cesmail.net ([216.154.195.49]:51867 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab0CRRZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:25:27 -0400
Subject: Re: [PATCH v2 4/7] drivers/net/wireless: Use STD_IW_HANDLER macro
From: Pavel Roskin <proski@gnu.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Corey Thomas <coreythomas@charter.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <b628c684e970196a7c4c0966ddd599a4c2ce293e.1268892664.git.joe@perches.com>
References: <cover.1268892663.git.joe@perches.com>
	 <b628c684e970196a7c4c0966ddd599a4c2ce293e.1268892664.git.joe@perches.com>
Content-Type: text/plain
Date: Thu, 18 Mar 2010 13:25:26 -0400
Message-Id: <1268933126.24544.18.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 23:21 -0700, Joe Perches wrote:
> Convert direct uses of [ (foo - SIOCIWFIRST) , fn)
> 
> Signed-off-by: Joe Perches <joe@perches.com>
...
>  static const iw_handler	wl3501_handler[] = {
> -	[SIOCGIWNAME	- SIOCIWFIRST] = wl3501_get_name,
...
> +	STD_IW_HANDLER(SIOCGIWNAME, wl3501_get_name),

You are introducing an unnecessary cast here.  That's bad.

-- 
Regards,
Pavel Roskin
