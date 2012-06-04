Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab2FDG5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 02:57:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59495 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2FDG5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 02:57:16 -0400
Date: Mon, 4 Jun 2012 07:57:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: gerg@snapgear.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] nommu: fix compilation of nommu.c
Message-ID: <20120604065712.GX30000@ZenIV.linux.org.uk>
References: <1338784199-19286-1-git-send-email-gerg@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338784199-19286-1-git-send-email-gerg@snapgear.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 02:29:59PM +1000, gerg@snapgear.com wrote:
> From: Greg Ungerer <gerg@uclinux.org>
> 
> Compiling 3.5-rc1 for nommu targets gives:
> 
>   CC      mm/nommu.o
> mm/nommu.c: In function ???sys_mmap_pgoff???:
> mm/nommu.c:1489:2: error: ???ret??? undeclared (first use in this function)
> mm/nommu.c:1489:2: note: each undeclared identifier is reported only once for each function it appears in
> 
> It is trivially fixed by replacing 'ret' with the local variable that is
> already defined for the return value 'retval'.
> 
> Signed-off-by: Greg Ungerer <gerg@uclinux.org>

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
