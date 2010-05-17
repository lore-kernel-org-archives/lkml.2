Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0EQHDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:03:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35873 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab0EQHDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:03:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Srinivas Nayak <sinu.nayak2001@gmail.com>
Subject: Re: Which function returns LWP in Linux.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikD7M_PKH3YgOWIvrcD6aW6X-gYIo2iw52QRRq_@mail.gmail.com>
References: <AANLkTikD7M_PKH3YgOWIvrcD6aW6X-gYIo2iw52QRRq_@mail.gmail.com>
Message-Id: <20100517160319.A195.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 17 May 2010 16:03:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> For a process, we have different PIDs. For threads under a single
> processes, we have different LWP id, but same PID in Linux.
> ex.
> 
> root@pc:/home/srinivas# ps -eLf
> UID        PID  PPID     LWP  C STIME       TIME     CMD
> root       100     1     100  0 May13       00:00:02 ./a.out
> root       100     1     102  0 May13       00:00:00 ./a.out
> 
> getpid() function returns PID of a process.
> Which function retuns LWP id for thread?

gettid()



