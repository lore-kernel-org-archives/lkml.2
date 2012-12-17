Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2LQRMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:12:09 -0500
Received: from tex.lwn.net ([70.33.254.29]:37891 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab2LQRMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:12:08 -0500
Date: Mon, 17 Dec 2012 10:14:39 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Marcos Lois =?UTF-8?B?QmVybcO6ZGV6?= <marcos.discalis@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jake Edge <jake@lwn.net>
Subject: Re: Question about using new request_threaded_irq
Message-ID: <20121217101439.399a3e8d@lwn.net>
In-Reply-To: <50CF4313.1010706@gmail.com>
References: <50CF361A.1030203@gmail.com>
	<20121217083759.0cbed418@lwn.net>
	<50CF4313.1010706@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 17:06:43 +0100
Marcos Lois Bermúdez <marcos.discalis@gmail.com> wrote:

> I'm a bit confusing because i see a outdated page that talks about this 
> new IRQ API, but now i see that it's very outdated:
> 
> http://lwn.net/Articles/302043/

I normally encourage people to rely on LWN for everything, of course -
even the articles that Jake writes :)  But that *was* four years ago; a
lot of things change in the kernel in that much time. 

Out of curiosity, I looked back at the old thread and the article did,
indeed, accurately match the API proposed at that time. The order of those
arguments got switched at some later point.

The moral of the story: when in doubt, check the source.

jon
