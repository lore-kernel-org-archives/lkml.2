Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0I2Bpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:45:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39497 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754039Ab0I2Bpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:45:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+LNiUqS0SLjrSx5HwpxpedLX+jqBtRwwx4okH/L9
	/JH2moE3qWTMBD
Subject: Re: [PATCH 0/3][RFC] Improve load balancing when tasks have large
 weight differential
From: Mike Galbraith <efault@gmx.de>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTin=Dic2UE55yUaam8NzGHTib=9s=x-wyzk03BU0@mail.gmail.com>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
	 <1285682273.7469.3.camel@marge.simson.net>
	 <AANLkTin=Dic2UE55yUaam8NzGHTib=9s=x-wyzk03BU0@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Sep 2010 03:45:58 +0200
Message-Id: <1285724758.7440.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 14:15 -0700, Nikhil Rao wrote:

> Thanks for running this. I've not been able to reproduce what you are
> seeing on the few test machines that I have (different combinations of
> MC, CPU and NODE domains). Can you please give me more info about
> your setup?

It's a plain-jane Q6600 box, so has only MC and CPU domains.

It doesn't necessarily _instantly_ "stick", can take a couple tries, or
a little time.

	-Mike

