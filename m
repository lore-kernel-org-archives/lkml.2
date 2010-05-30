Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab0E3TEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 15:04:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59263 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0E3TEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 15:04:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C02B483.9080802@s5r6.in-berlin.de>
Date: Sun, 30 May 2010 20:54:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: core: check for 1394a compliant IRM,	fix inaccessibility
 of Sony camcorder
References: <AANLkTimIFRbKWYjFd56acxT2A6nnH6l3-7Q_UyORnonW@mail.gmail.com>	<4C017477.8000008@s5r6.in-berlin.de>	<4C0284E7.3050803@s5r6.in-berlin.de>	<tkrat.740b506673ccbf6d@s5r6.in-berlin.de> <htu993$60f$1@dough.gmane.org>
In-Reply-To: <htu993$60f$1@dough.gmane.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.S. wrote:
> Stefan Richter wrote:
> <SNIP>
>> The patch was generated against the latest kernel sources but is
>> applicable with harmless line offsets to the 2.6.32.y stable kernel
>> series too.  Hence it should be applicable to Debian's 2.6.32 sources as
>> well.
>>
>> H. S., could you please test this?
> 
> Yes, I can give it a shot. Please pardon this basic question, should I
> be downloading the vanilla kernel source, patching it, compiling it and
> then testing it?

Either this or the sources of the Debian kernel that you are currently
running.  The latter may perhaps be preferable for an easier switch
between distributed kernel and patched kernel.

> Or is there a precompiled binary available for download
> (i368 or amd64) with this patch included?

Alas not.
(I could build such a package if I had Debian myself, but I don't.)

> I admit I have never patched
> and compiled a kernel before for testing a patch. I have, however,
> compiled kernels numerous times quite a while ago (just for learning
> objectives).

OK; the patching as additional step is going to be the easiest one.

A quick web search turned up the following pointers for using a custom
kernel on Debian:
http://www.debian.org/doc/FAQ/ch-kernel.en.html
http://www.debian.org/releases/stable/i386/ch08s06.html.en
(I hope the described method provides an already configured kernel
source tree with Debian's configuration as baseline.)

Before you start compilation, save the email with the patch somewhere,
change into the top-level directory of the kernel sources, and apply the
patch with "patch -p1 < /the/path/to/the/email".
-- 
Stefan Richter
-=====-==-=- -=-= ====-
http://arcgraph.de/sr/
