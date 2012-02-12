Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2BLVUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 16:20:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36993 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2BLVUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 16:20:38 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 12 Feb 2012 22:20:27 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Naveen Goswamy <naveen.goswamy@polymtl.ca>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: Kernel crashing on eject SD card
Message-ID: <20120212222027.71651e8b@stein>
In-Reply-To: <20120212220836.6aa7fa4d@stein>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
	<20120212220836.6aa7fa4d@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12 Stefan Richter wrote:
> Modules linked in: [...] vboxnetadp(O) vboxnetflt(O) vboxdrv(O) [...]

Oh, could you try without virtualbox?

The debian bug report hints that kernel 3.2 /without virtualbox drivers/
seems to behave itself.
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=649735
-- 
Stefan Richter
-=====-===-- --=- -==--
http://arcgraph.de/sr/
