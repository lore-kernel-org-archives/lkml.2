Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2BMBrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 20:47:07 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:59599 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2BMBrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 20:47:06 -0500
Message-ID: <1329097617.4f386b91792a3@www.imp.polymtl.ca>
Date: Sun, 12 Feb 2012 20:46:57 -0500
From: Naveen Goswamy <naveen.goswamy@polymtl.ca>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Kernel crashing on eject SD card
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca> <20120212220836.6aa7fa4d@stein> <20120212222027.71651e8b@stein>
In-Reply-To: <20120212222027.71651e8b@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.3
X-Originating-IP: 76.10.169.205
X-Poly-FromMTA: (imp-4-3.polymtl.ca [132.207.4.78]) at Mon, 13 Feb 2012 01:46:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I confirm that it behaves properly when virtualbox drivers are not loaded.

Cheers,

Naveen


Quoting Stefan Richter <stefanr@s5r6.in-berlin.de>:

> On Feb 12 Stefan Richter wrote:
> > Modules linked in: [...] vboxnetadp(O) vboxnetflt(O) vboxdrv(O) [...]
>
> Oh, could you try without virtualbox?
>
> The debian bug report hints that kernel 3.2 /without virtualbox drivers/
> seems to behave itself.
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=649735
> --
> Stefan Richter
> -=====-===-- --=- -==--
> http://arcgraph.de/sr/
>



