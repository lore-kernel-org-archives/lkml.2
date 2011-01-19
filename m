Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1ASFc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:32:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34617
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab1ASFcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:32:55 -0500
Date: Tue, 18 Jan 2011 21:33:27 -0800 (PST)
Message-Id: <20110118.213327.27785301.davem@davemloft.net>
To: ian.molton@collabora.co.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, ebiederm@xmission.com, xemul@openvz.org,
        davidel@xmailserver.org, alban.crequy@collabora.co.uk
Subject: Re: [PATCH] af_unix: implement socket filter
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295368755-20931-1-git-send-email-ian.molton@collabora.co.uk>
References: <1295368755-20931-1-git-send-email-ian.molton@collabora.co.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Molton <ian.molton@collabora.co.uk>
Date: Tue, 18 Jan 2011 16:39:15 +0000

> From: Alban Crequy <alban.crequy@collabora.co.uk>
> 
> Linux Socket Filters can already be successfully attached and detached on unix
> sockets with setsockopt(sockfd, SOL_SOCKET, SO_{ATTACH,DETACH}_FILTER, ...).
> See: Documentation/networking/filter.txt
> 
> But the filter was never used in the unix socket code so it did not work. This
> patch uses sk_filter() to filter buffers before delivery.
> 
> This short program demonstrates the problem on SOCK_DGRAM.
...
> Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
> Reviewed-by: Ian Molton <ian.molton@collabora.co.uk>

Applied.
