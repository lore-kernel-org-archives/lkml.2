Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab0GQJIq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 05:08:46 -0400
Received: from khc.piap.pl ([195.187.100.11]:43112 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab0GQJIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 05:08:44 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Ben Collins <bcollins@bluecherry.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Solo6010 staging driver - kernel panic
References: <m3ocehdk4h.fsf@intrepid.localdomain>
Date: Sat, 17 Jul 2010 11:08:42 +0200
In-Reply-To: <m3ocehdk4h.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Fri, 09 Jul 2010 12:28:46 +0200")
Message-ID: <m3y6da3279.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> I'm trying to use your solo6x10 driver with a card based on 6010 chip.
> The driver seems to detect the card correctly, but when I open
> /dev/video0 and then close it, I got a kernel panic. I traced the
> problem to invalid pointers in q->bufs[i]->queue in a call to
> videobuf_queue_cancel().

BTW I have fixed it and will work on this driver a bit.
Will post the results soon.
-- 
Krzysztof Halasa
