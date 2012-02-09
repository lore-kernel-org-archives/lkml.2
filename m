Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab2BIGOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:14:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:44524 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab2BIGOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:14:32 -0500
Message-ID: <1328768063.2903.70.camel@pasglop>
Subject: Re: [PATCH 15/21] powerpc: Use generic posix_types.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>
Date: Thu, 09 Feb 2012 17:14:23 +1100
In-Reply-To: <1328677745-20121-16-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
	 <1328677745-20121-16-git-send-email-hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 21:08 -0800, H. Peter Anvin wrote:

 .../...

>  #else
> -typedef unsigned short	__kernel_nlink_t;
> -typedef short		__kernel_ipc_pid_t;
>  typedef unsigned int	__kernel_size_t;

This followed later by ...

> +typedef int		__kernel_size_t;

This, I suspect the second one wanted to be ssize_t :-)

The rest looks ok, I'll try to build tomorrow.

Cheers,
Ben.


