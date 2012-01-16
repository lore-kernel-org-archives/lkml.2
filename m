Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2APGxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 01:53:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33438 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2APGxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 01:53:33 -0500
Message-ID: <1326696808.5287.115.camel@edumazet-laptop>
Subject: Re: Why the number of /proc/interrupts doesn't change when nic is
 under heavy workload?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yuehai Xu <yuehaixu@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, yhxu@wayne.edu
Date: Mon, 16 Jan 2012 07:53:28 +0100
In-Reply-To: <CAEc1PS0QxYfHfLFTiSFdTX27ufuxVfJd6Vg5oyv5aip5r=tD4A@mail.gmail.com>
References: <CAEc1PS0doeaH59621ia7n2GT=WgRSsCit_EzGrCV93QH95XZqw@mail.gmail.com>
	 <1326665367.5287.97.camel@edumazet-laptop>
	 <CAEc1PS0QxYfHfLFTiSFdTX27ufuxVfJd6Vg5oyv5aip5r=tD4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 15 janvier 2012 à 17:27 -0500, Yuehai Xu a écrit :
> Thanks for replying! Please see below:

> My memcached uses 8 different UDP sockets(8 different UDP ports), so
> there should be no lock contention for a single UDP rx-queue.

Ah, I missed this mail, so you really should post here result of "perf
top -C 0", after you make sure your NIC interrupts are handled by cpu 0.

Also, what speed is your link, and how many UDP messages per second do
you receive ?



