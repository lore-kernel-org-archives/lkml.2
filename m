Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0KNTpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 14:45:22 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41339 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab0KNTpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 14:45:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ngHHH4fivUhEUJvLU45Bujn+zN0shMEFi7TCkZX8//nFi8U0ENXyZ85Mc1oMj+A66p
         +h5c/7i/iraMk0Vy/tLWoI2nwuRSYm2qUJHXoZ22IJ3Uv61lqRp0L82MR9Gv1n9xMwXU
         XJ10LE5a7aFkJQPMRBKJa7S4aWx+whxzYG/eQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Marin Mitov <mitov@issp.bas.bg>
Subject: Re: [BUG]: skge not working (as module) in 2.6.37-rc1
Date: Sun, 14 Nov 2010 20:45:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: Stephen Hemminger <shemminger@osdl.org>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <201011072345.52784.mitov@issp.bas.bg>
In-Reply-To: <201011072345.52784.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011142045.14627.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 7 listopada 2010 o 22:45:52 Marin Mitov wrote:
> Hi Stephen,
> 
> skge as in 2.6.36 (and before) is working.
> As in 2.6.37-rc1 it is not:
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=22892
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
