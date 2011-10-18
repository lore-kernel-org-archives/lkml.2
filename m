Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1JRUvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 16:51:37 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:57284 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab1JRUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 16:51:36 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Oct 2011 16:51:36 EDT
Date: Tue, 18 Oct 2011 22:41:26 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: raviraj joshi <raviraj.j1991@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kenel level packet capturing
Message-ID: <20111018224126.0d0510f4@neptune.home>
In-Reply-To: <CAKj1SsP+GE=QqN8nx7aaAxXE8BODKb=vns_=SnbyySQjZp3-pg@mail.gmail.com>
References: <CAKj1SsP+GE=QqN8nx7aaAxXE8BODKb=vns_=SnbyySQjZp3-pg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You would probably have more/better replies if you asked netdev <netdev@vger.kernel.org>.

On Tue, 18 October 2011 raviraj joshi <raviraj.j1991@gmail.com> wrote:
> We are making a kernel level packet capture module as a part of our BE project .
> We are finding it difficult to understand kenel networking code.
> We studied structures and functions like sk_buff, netif_rx(),dev_alloc_skb.
> How ever we were not able to trace the actual path a simple packet follows.
> Moreover we tried to count the no of times netif_rx function was
> called it was much much lower than amount of packets actually being
> received.

netif_rx may fetch more than a single packet from the network interface
controller in order to improve performance.

> Can anyone please let us know the reason for this and how to approach
> the problem of writing a kernel level packet capture module.

The better place to capture packets is probably by hooking somewhere into
netfilter code as all packets traverse it (assuming it is loaded/enabled).

Bruno


> regards,
> Raviraj Joshi
> PICT,Pune.
