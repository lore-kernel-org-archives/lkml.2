Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687Ab2EDXd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:33:27 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:3075 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab2EDXdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:33:25 -0400
Date: Sat, 5 May 2012 09:30:00 +1000
From: Chris Jones <chrisjones@spin.net.au>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mark Lord <kernel@teksavvy.com>
Subject: Re: Hard drive detection
Message-ID: <20120505093000.1d9789dd@ubuntu>
In-Reply-To: <4FA3D60F.9090601@teksavvy.com>
References: <20120504185604.3addfd2e@ubuntu>
	<4FA3D60F.9090601@teksavvy.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.967, required 4, AWL 0.53, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2012 09:13:51 -0400
Mark Lord <kernel@teksavvy.com> wrote:

> On 12-05-04 04:56 AM, Chris Jones wrote:
> > What section of the kernel detects internal hard drives upon boot?
> 
> That depends upon how the drive is connected.
> But generally speaking, the device driver for the drive-controller
> will probe and find any attached drives.
> 
> So for modern kernels, on systems with SATA drives,
> the code is in linux/drivers/ata/
> 
> 

Thanks Mark. That's exactly what I was looking for. And are both PATA
and SATA internal drives both located in drivers/ata?


Regards

Chris Jones
