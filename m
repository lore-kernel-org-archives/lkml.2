Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab2AFU5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:57:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61915 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab2AFU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:57:04 -0500
Message-ID: <4F07601D.3050504@lwfinger.net>
Date: Fri, 06 Jan 2012 14:57:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rtlwifi: Simplify chip version id logging
References: <0f80cb0e369db8c8884d4a1d46e70a60c1dfb19c.1325878172.git.joe@perches.com> <066ccb110481f572dd34b5fc83671194f3d2e00a.1325878172.git.joe@perches.com>
In-Reply-To: <066ccb110481f572dd34b5fc83671194f3d2e00a.1325878172.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 01:31 PM, Joe Perches wrote:
> Reduce object size a few KB too.
>
> $ size drivers/net/wireless/rtlwifi/built-in.o*
>     text	   data	    bss	    dec	    hex	filename
>   584493	  55333	 126800	 766626	  bb2a2	drivers/net/wireless/rtlwifi/built-in.o.new
>   586904	  55333	 127216	 769453	  bbdad	drivers/net/wireless/rtlwifi/built-in.o.old
>
> Signed-off-by: Joe Perches<joe@perches.com>

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
