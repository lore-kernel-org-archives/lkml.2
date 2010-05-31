Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0EaXzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:55:38 -0400
Received: from xenotime.net ([72.52.115.56]:44079 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751309Ab0EaXzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:55:37 -0400
Date: Mon, 31 May 2010 16:55:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible bug in 2.6.34 slub
Message-Id: <20100531165528.35a323fb.rdunlap@xenotime.net>
In-Reply-To: <AANLkTimEFy6VM3InWlqhVooQjKGSD3yBxlgeRbQC2r1L@mail.gmail.com>
References: <AANLkTimEFy6VM3InWlqhVooQjKGSD3yBxlgeRbQC2r1L@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 01:39:43 +0200 Giangiacomo Mariotti wrote:

> Hi, I've recently noticed this line on the dmesg output(kernel 2.6.34):
> [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
> CPUs=16, Nodes=1
> 
> My cpu is an I7 920, so it has 4 cores and there's hyperthreading
> enabled, so there are 8 logical cpus. Is this a bug?


No, it's just some boot/init time information.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
