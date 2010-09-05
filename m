Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0IEVUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 17:20:25 -0400
Received: from xenotime.net ([72.52.115.56]:33657 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751367Ab0IEVUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 17:20:24 -0400
Date: Sun, 5 Sep 2010 14:20:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: runcoderen <runcoderzhcn@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ldd scull_load question
Message-Id: <20100905142020.5db3997d.rdunlap@xenotime.net>
In-Reply-To: <1283648515.1741.8.camel@bencharluo-laptop>
References: <1283160040-6636-1-git-send-email-nab@linux-iscsi.org>
	<201009020156.53803.konrad@darnok.org>
	<1283455187.5598.86.camel@haakon2.linux-iscsi.org>
	<1283644390.556.74.camel@haakon2.linux-iscsi.org>
	<1283646914.1741.3.camel@bencharluo-laptop>
	<20100904174308.409c070e.rdunlap@xenotime.net>
	<1283648515.1741.8.camel@bencharluo-laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Sep 2010 09:01:55 +0800 runcoderen wrote:

> yes, you do!
> 
> there is another question confused me.
> I have seem the command in the scull.c:
> int scull_major = SCULL_MAJOR;and so on.
> 
> module_param(scull_major, int, S_IRUGO); and so on.
> 
> if we don't do "./scull_load scull_major" command.
> 
> we just use "./scull_load"
> 
> it will make scull_major = SCULL_MAJOR default?

Yes.  scull_major is initialized to SCULL_MAJOR every time
that the module is loaded.
The module_param() allows someone to change the value of
scull_major.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
