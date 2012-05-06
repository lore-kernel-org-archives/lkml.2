Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2EFR4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:56:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44831 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2EFR4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:56:50 -0400
Date: Sun, 6 May 2012 18:56:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
Message-ID: <20120506175649.GV6871@ZenIV.linux.org.uk>
References: <20120506162000.GT6871@ZenIV.linux.org.uk>
 <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com>
 <20120506175451.GU6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506175451.GU6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 06:54:51PM +0100, Al Viro wrote:
> everywhere (AFAICS) else: "is this a 32bit syscall" vs. "is this a biarch
> syscall with 32bit pointers, etc.".  On architectures where 32bit syscall
  ^^^^^^^
 "process", of course...
