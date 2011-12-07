Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab1LGSiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:38:52 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46480 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab1LGSiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:38:51 -0500
Date: Wed, 07 Dec 2011 13:38:43 -0500 (EST)
Message-Id: <20111207.133843.479723484713242318.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: tixxdz@opendz.org, xeb@mail.ru, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ppp: fix pptp double release_sock in pptp_bind()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323233994.2690.29.camel@edumazet-laptop>
References: <20111207014712.GB25869@dztty>
	<1323233994.2690.29.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Dec 2011 10:38:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 07 Dec 2011 05:59:54 +0100

> Le mercredi 07 décembre 2011 à 02:47 +0100, Djalal Harouni a écrit :
>> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
 ...
> Nice catch !
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
