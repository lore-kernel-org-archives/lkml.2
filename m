Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1CQHyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 03:54:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44648 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751262Ab1CQHyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 03:54:49 -0400
Content-Type: text/plain; charset="utf-8"
Date: Thu, 17 Mar 2011 08:54:45 +0100
From: "walter schloegl" <sctp@muskelshirt.de>
In-Reply-To: <20110317074356.231320@gmx.net>
Message-ID: <20110317075445.231310@gmx.net>
MIME-Version: 1.0
References: <20110317074356.231320@gmx.net>
Subject: Re: sctp panic
To: linux-kernel@vger.kernel.org
X-Authenticated: #113584424
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18ry1BpqForIzUkLSodqp3A8IIdyLlbEE9Cw7Hvp0
 sK1W0UBn8Oh2nLgmJREu2qlSePGI3mI1eaWg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: fYy4eGAXeWUoVUBItnNzcJIxU3U4N49r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi
> 
> when doing the actions below I get a panic.
> 
> - echo 1 > /proc/sys/net/sctp/addip_enable 
> - In a C-Programm  
>     - socket(AF_INET,SOCK_STREAM,IPPROTO_SCTP);  
>     - connect(....)     (with correct filled parameters)
> 
> Its no process (waiting in accept) neccessary

>> I forgot:
>> 2.6.32-71.18.1.el6.x86_64 #1 SMP Wed Feb 2 17:49:59 EST 2011 x86_64 x86_64 x86_64 GNU/Linux

> 
> br
> walter
> -- 
-- 
GMX DSL Doppel-Flat ab 19,99 Euro/mtl.! Jetzt mit 
gratis Handy-Flat! http://portal.gmx.net/de/go/dsl
