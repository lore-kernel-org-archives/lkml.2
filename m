Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab0KXUTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:19:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:43015 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab0KXUTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:19:45 -0500
Date: Wed, 24 Nov 2010 12:18:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] SEP cleanups
Message-Id: <20101124121833.8c48619c.randy.dunlap@oracle.com>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010 19:23:46 +0000 Alan Cox wrote:

> This is a rework from the bits I sent you a while back Mark (which I suspect
> got eaten in the email) and some other cleanup. I've not beaten it up with
> CodingStyle yet because most of the debug wants removing before that is done
> so it is probably more productive to fix the logic and the inherited choice of
> TRUELY_GIANT_DEFINE_NAMES_THAT_CAUSE_MUCH_WRAPPING before we worry about finer
> points of style.

TRULY.  (or is that Brit. vs. Amer.?)



How about someone addressing these printk format warnings (linux-next)?

drivers/staging/sep/sep_driver.c:115: warning: format '%08x' expects type 'unsigned int', but argument 4 has type 'size_t'
drivers/staging/sep/sep_driver.c:149: warning: format '%08x' expects type 'unsigned int', but argument 4 has type 'size_t'
drivers/staging/sep/sep_driver.c:170: warning: format '%08x' expects type 'unsigned int', but argument 4 has type 'size_t'
drivers/staging/sep/sep_driver.c:212: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'size_t'
drivers/staging/sep/sep_driver.c:3397: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'
drivers/staging/sep/sep_driver.c:3399: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'
drivers/staging/sep/sep_driver.c:3405: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'
drivers/staging/sep/sep_driver.c:3407: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'
drivers/staging/sep/sep_driver.c:3411: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'
drivers/staging/sep/sep_driver.c:3413: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'
drivers/staging/sep/sep_driver.c:3415: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'
drivers/staging/sep/sep_driver.c:3738: warning: format '%x' expects type 'unsigned int', but argument 6 has type 'size_t'
drivers/staging/sep/sep_driver.c:3866: warning: format '%x' expects type 'unsigned int', but argument 6 has type 'size_t'



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
