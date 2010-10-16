Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab0JPPGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 11:06:43 -0400
Received: from xenotime.net ([72.52.115.56]:48266 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750965Ab0JPPGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:06:41 -0400
Date: Sat, 16 Oct 2010 08:06:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "werner" <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc1 problems
Message-Id: <20101016080637.dd74533f.rdunlap@xenotime.net>
In-Reply-To: <web-387129929@zbackend1.aha.ru>
References: <web-387129929@zbackend1.aha.ru>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2 things:

a.  Please test & report on something more current.

b.  Please post errors & warnings so that they are listed without extra
line breaks.  This is messy.


On Fri, 15 Oct 2010 19:23:38 -0400 werner wrote:

> drivers/staging/comedi/drivers/das08_cs.c:225: error: 
> 'struct pcmcia_device' has
> no member named 'io'

That should all be on one (long) line.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
