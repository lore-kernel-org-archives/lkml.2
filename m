Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2JEWAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:00:34 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:37128 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2JEWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:00:31 -0400
Date: Fri, 5 Oct 2012 23:40:41 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: davem@davemloft.net, rick.jones2@hp.com, netdev@pradeepdalvi.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/20 V2] drivers/net/ethernet/natsemi/natsemi.c: fix error return code
Message-ID: <20121005214041.GA11601@electric-eye.fr.zoreil.com>
References: <1349469667-6137-1-git-send-email-peter.senna@gmail.com> <1349469667-6137-2-git-send-email-peter.senna@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349469667-6137-2-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Senna Tschudin <peter.senna@gmail.com> :
[...]
> The function natsemi_probe1() return 0 for success and negative value
> for most of its internal tests failures. There is one exception
> that is error case going to err_create_file:. Fore this error case the
> function abort its success execution path, but returns non negative value, 
> making it difficult for a caller function to notice the error.

Ok. natsemi_probe1() forgets to return a negative status code in one of
its failure paths.

[...]
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Acked-by: Francois Romieu <romieu@fr.zoreil.com>

-- 
Ueimor
