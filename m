Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2LEPyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:54:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50084 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab2LEPx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:53:59 -0500
Date: Wed, 5 Dec 2012 16:53:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bokhan Artem <art@eml.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at /build/buildd/linux-2.6.32/mm/mempolicy.c
Message-ID: <20121205155357.GB12119@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Bokhan Artem <art@eml.ru>,
	linux-kernel@vger.kernel.org
References: <50BF66A0.1050503@eml.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50BF66A0.1050503@eml.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 10:22:08PM +0700, Bokhan Artem wrote:
> Hello.
> 
> We have several servers with mongodb running. Each server has
> several mongodb instances. Mongodb dataset is larger then availiable
> memory (mongodb uses memory-mapped files for all disk I/O).
> 2.6.32 and 2.6.38 kernels periodically crash and crash happens only
> with mongodb servers.
> 
> 2.6.38's trace is in attachment.
> For 2.6.32 I only have "kernel BUG at
> /build/buildd/linux-2.6.32/mm/mempolicy.c:1489!"

Can you reproduce this with the current upstream kernel 3.7-rc8? If no,
then you should complain to the ubuntu people or whoever provides your
kernels.

-- 
Regards/Gruss,
    Boris.
