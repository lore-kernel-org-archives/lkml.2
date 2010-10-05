Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab0JEVzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:55:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46761
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040Ab0JEVzD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:55:03 -0400
Date: Tue, 05 Oct 2010 14:55:24 -0700 (PDT)
Message-Id: <20101005.145524.35829931.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: alban.crequy@collabora.co.uk, lennart@poettering.net,
        shemminger@vyatta.com, gorcunov@openvz.org, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] AF_UNIX: Implement SO_TIMESTAMP and SO_TIMETAMPNS on
 Unix sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1286220052.2381.70.camel@edumazet-laptop>
References: <20101004194734.6a1caf3e@chocolatine.cbg.collabora.co.uk>
	<1286218109-30771-1-git-send-email-alban.crequy@collabora.co.uk>
	<1286220052.2381.70.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 04 Oct 2010 21:20:52 +0200

> Le lundi 04 octobre 2010 à 19:48 +0100, Alban Crequy a écrit :
>> Userspace applications can already request to receive timestamps with:
>> setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMP, ...)
>> 
>> Although setsockopt() returns zero (success), timestamps are not added to the
>> ancillary data. This patch fixes that on SOCK_DGRAM and SOCK_SEQPACKET Unix
>> sockets.
>> 
>> Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
