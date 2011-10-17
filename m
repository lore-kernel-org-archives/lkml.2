Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1JQMkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:40:24 -0400
Received: from 2605ds1-ynoe.0.fullrate.dk ([90.184.12.24]:49821 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab1JQMkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:40:15 -0400
Message-ID: <e78a7c38af135cee4b742c99ecd1c011.squirrel@shrek.krogh.cc>
In-Reply-To: <20111011133448.GA10692@infradead.org>
References: <20111011091757.GA32589@otto.nzcorp.net>
    <20111011133448.GA10692@infradead.org>
Date: Mon, 17 Oct 2011 14:40:07 +0200 (CEST)
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O 
     load
From: jesper@krogh.cc
To: "Christoph Hellwig" <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, aradford@gmail.com, xfs@oss.sgi.com
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 11, 2011 at 11:17:57AM +0200, Anders Ossowicki wrote:
>> Pid: 27512, comm: flush-8:32 Tainted: G        W   2.6.38.8 #1 Dell Inc.
>>  PowerEdge R815/04Y8PT
>> RIP: 0010:[<ffffffff810f8d71>]  [<ffffffff810f8d71>]
>> find_get_pages+0x61/0x110
>
> This is core VM code, and operates purely on on-stack variables except
> for the page cache radix tree nodes / pages.  So this either could be a
> core VM bug that no one has noticed yet, or memory corruption.  Can you
> run memtest86 on the box?

Over the weekend, we have run memtest for 4 hours (50% of the complete
tests according to memtest) and it didnt find anything.

We've also backpatched the raid-driver into 2.6.37 and the problem continued,
so it seems to be related to the driver and/or combinations with hardware.

Jesper
-- 
Jesper

