Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0DRMHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 08:07:50 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:55809 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab0DRMHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 08:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lKHEpT/JtQ+LX32aWS/l6GRHfPZeUQxwImlQ7gAPm+0YARj0klmDqjAz7xdtE11WJC
         TTOG0+D3KknI82Qat5hQoCevWK89Zq7lHq+vFHQzIYmHAwrPO2Wb4j17sFOZjHWdKO3u
         feAyBVxx/dGOIZuhku7RbVS+K/NG5CnHNltAw=
Subject: Re: Network activity after route changes
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oleg Kutkov <elenbert@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4BCAE9BC.3090609@gmail.com>
References: <4BC9DB9A.9090605@gmail.com>  <4BCAE9BC.3090609@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Apr 2010 14:07:41 +0200
Message-ID: <1271592461.16881.4960.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 18 avril 2010 à 14:15 +0300, Oleg Kutkov a écrit :
> Hello.
> I try to send and receive ethernet packets on very low level in my 
> kernel module.
> When i change (add or delete entry) routin table (via route command) my 
> network is freeze for ~15 seconds and my application can't send and 
> receive any packets.
> Is it normal or bug somewhere in my application?
> Can i change this behavior of route system? Maybe change some timeouts, 
> or immediately flush route (rt_flush() ?) table?
> 
> Thanks.

I guess its a bug in your module, since user apps dont experience this
interesting phenomena :)



