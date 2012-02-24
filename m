Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2BXNrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:47:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59433 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab2BXNrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:47:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.68.135.34 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <5240114.8TkZqEVLeL@fodrek.kar.elf.stuba.sk>
References: <5240114.8TkZqEVLeL@fodrek.kar.elf.stuba.sk>
Date: Fri, 24 Feb 2012 21:47:47 +0800
Message-ID: <CAJd=RBCdxEv=OATcNw1yugCF7g=Ba8fFLQE0D6QTAkO8BRoqrQ@mail.gmail.com>
Subject: Re: Resening: KGDB over Ethternet howto patch
From: Hillf Danton <dhillf@gmail.com>
To: fodrek@kasr.elf.stuba.sk
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 9:01 PM,  <fodrek@kasr.elf.stuba.sk> wrote:
>
> This module serves a hard realime RTAI application and we are to debug it
> using Ethernet insatead of RS232/RS485 or other UART port as is  possible
> out of box. We are familiar to use gdb as weel as for remote debuging of the
> usewr space application but not debuging kernel.
>

Perhaps you could google KGTP, and try to be another user of it.

Good weekend
-hd
