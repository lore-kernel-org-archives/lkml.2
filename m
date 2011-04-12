Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1DLLyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:54:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1DLLyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:54:32 -0400
Date: Tue, 12 Apr 2011 13:54:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Adam McLaurin <lkml@irotas.net>
Cc: Will Newton <will.newton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Loopback and Nagle's algorithm
In-Reply-To: <1302606246.21782.1440195277@webmail.messagingengine.com>
Message-ID: <alpine.LRH.2.00.1104121354010.6953@twin.jikos.cz>
References: <1302575869.13492.1440076201@webmail.messagingengine.com> <BANLkTi=jpdLRc35DkBhLmUr8-P+ggcrgoA@mail.gmail.com> <1302606246.21782.1440195277@webmail.messagingengine.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Adam McLaurin wrote:

> > It may be caused by an increase in context switch rate, as both sender
> > and receiver are on the same machine.
> 
> I'm not sure that's what's happening, since the box where I'm running
> this test has 8 physical CPU's and 32 cores in total.

Have you tried firing up the testcase under perf, to see what it reveals 
as the bottleneck?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

