Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0J0SlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:41:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33234 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab0J0SlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 14:41:20 -0400
MIME-Version: 1.0
Date: Wed, 27 Oct 2010 11:41:18 -0700
Message-ID: <AANLkTimCSGoeRHXWS2Y5=THbOkHUfY71=B6JzOeFz_=X@mail.gmail.com>
Subject: Tweaking swap algorithm under constrained memory usage
From: Pawan Singh <pawan@pinger.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a requirement where a user space process needs to allocate 75%
of the memory on the machine and keep it locked i.e. not swappable.
Other processes need to share the rest of the memory. Swap is enabled.
I was wondering what tweaks would be required so that the swapping
alogrithms' thresholds are based on 25% of the memory rather than on
100% of the memory. If I leave this at default, kswapd may decide to
swap a lot more pages than really required because 75% of pages are
locked. I am working on 2.6.22 kernel. I can use "swappiness" factor
and reduce it - but I wanted to know if I can alter something
fundamental in the kernel code to make life for rest of the processes
better.

Thanks for any suggestions.

-Pawan
