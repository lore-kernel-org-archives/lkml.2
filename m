Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab2EOBVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:21:42 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:42867 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932402Ab2EOBVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:21:41 -0400
Date: Tue, 15 May 2012 05:21:27 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120515012127.GE25482@ioremap.net>
References: <20120509222411.GA24302@kroah.com>
 <4FAAF1C4.2050500@hrz.tu-chemnitz.de>
 <20120509235723.GA7404@ioremap.net>
 <20120510000126.GA2357@kroah.com>
 <20120510004350.GA8362@ioremap.net>
 <4FAB4A4D.8080901@hrz.tu-chemnitz.de>
 <20120510151639.GE17472@kroah.com>
 <4FAC47F6.6080903@hrz.tu-chemnitz.de>
 <20120510230445.GA11918@kroah.com>
 <4FACAE19.2070609@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FACAE19.2070609@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 08:13:45AM +0200, Markus Franke (markus.franke@s2002.tu-chemnitz.de) wrote:
> There is not even a single 1-wire driver mentioned within
> Documentation/ABI. In which subdirectory shall I put my documentation
> file into? stable?

I believe it is ok to add w1 dir there and describe all your ssyfs files
Feel free to document others :)

-- 
	Evgeniy Polyakov
