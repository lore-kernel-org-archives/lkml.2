Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1DER1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:27:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:51510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1DER1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:27:46 -0400
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110405 release
From: Peter Zijlstra <peterz@infradead.org>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>
In-Reply-To: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com>
References: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 19:27:38 +0200
Message-ID: <1302024458.2225.1350.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 19:59 +0800, Hui Zhu wrote:
> KGTP is a realtime and lightweight Linux Kernel GDB debugger and
> tracer that use Kprobe.
> 
> It make Linux Kernel supply a GDB remote debug interface. Then GDB in
> current machine or remote machine(see "Make GDB connect to gtp") can
> debug Linux through GDB tracepoint without stop the Linux Kernel.
> And even if the board doesn't have GDB on it and doesn't have
> interface for remote debug. It can debug the Linux Kernel use offline
> debug (See "Offline debug"). 

So this leaves me wondering how this is different from the existing
KGDB, if its different why its not reusing/extending the existing
infrastructure.


