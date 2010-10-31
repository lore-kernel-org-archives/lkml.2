Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0JaSIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 14:08:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60527 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab0JaSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 14:08:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CCDB0AA.3060505@s5r6.in-berlin.de>
Date: Sun, 31 Oct 2010 19:08:42 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: is there some kind of standard for "inline" these days?
References: <alpine.DEB.2.00.1010311342520.18295@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.00.1010311342520.18295@localhost6.localdomain6>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   i asked about this some time ago and i'm curious -- is there a
> simple standard for the use of "inline" in kernel code.  as of now,
> there are still uses of all of inline, __inline__ and __inline,

"grep inline include/linux/kernel.h" looks like a good guidance.

See also the C99 standard and maybe
http://gcc.gnu.org/onlinedocs/gcc/Alternate-Keywords.html .
-- 
Stefan Richter
-=====-==-=- =-=- =====
http://arcgraph.de/sr/
