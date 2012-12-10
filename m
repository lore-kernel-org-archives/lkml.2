Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2LJUMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:12:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49343 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2LJUMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:12:39 -0500
MIME-Version: 1.0
Date: Mon, 10 Dec 2012 15:12:38 -0500
Message-ID: <CALyraeOdiCD+cbQZoyRZYPmzC3Kzivk8daK=PYT8uT9HwFpacQ@mail.gmail.com>
Subject: netfilter question
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: linux-netdev <netdev@vger.kernel.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>,
        linux-newbie@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I am writing a netfilter hooks module for applying kernel rules on
incoming packets. I am implementing hook at NF_IP_PRE_ROUTING.

>From my understanding, after sk_buff passing NF_IP_PRE_ROUTING hook
enters into ip_forward (routing) path, which will determine whether
packet is for local host, if not for local host, then routes to
destination host based on IP header destination info through local
host interface.

My question is, if I modify sk_buff packet ip header info at
NF_IP_PRE_ROUTING hook, with values of external host ip (destination
host), therefore I think this packet will be routed to destination
host from right source interface. Instead passing it to local host.

Please correct my assumption. Or is anything more I should be doing.
Because I am building a system to route the packets applying kernel
rules.

thanks in advance.

-- 
Regards,
Sri.
