Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0JOF6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 01:58:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35298 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0JOF6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 01:58:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CB7ED67.2000407@s5r6.in-berlin.de>
Date: Fri, 15 Oct 2010 07:57:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Tom Brown <sa212+emis@cyconix.com>
CC: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang@windriver.com>
Subject: Re: Question: how to copy to user space from a tasklet
References: <4CB6DEC4.4040408@cyconix.com>
In-Reply-To: <4CB6DEC4.4040408@cyconix.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Brown wrote:
> [Sorry to have to ask this here - I can't find any driver-specific
> newsgroup or mailing lists - are there any??]

linux-newbie perhaps.

> I have a driver which needs to copy device data direct to user space
> from a tasklet.

One way would be to use mmap() to allocate the DMA buffer and insert it into
the user address space before DMA commences.  An additional poll/read/write
based protocol or so can be used for buffer management during DMA.
-- 
Stefan Richter
-=====-==-=- =-=- -====
http://arcgraph.de/sr/
