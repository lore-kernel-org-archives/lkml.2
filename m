Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab0JRBmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 21:42:22 -0400
Received: from xenotime.net ([72.52.115.56]:55760 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750801Ab0JRBmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 21:42:21 -0400
Date: Sun, 17 Oct 2010 18:42:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: scripts/extract-ikconfig only works on uncompressed and
 CONFIG_KERNEL_GZIP kernels
Message-Id: <20101017184213.1e63eae6.rdunlap@xenotime.net>
In-Reply-To: <loom.20101018T024559-314@post.gmane.org>
References: <loom.20101018T024559-314@post.gmane.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 00:48:46 +0000 (UTC) Alex Elsayed wrote:

> I have a kernel that was compiled with LZMA compression (CONFIG_KERNEL_LZMA). I
> wish to extract the .config from it without running it, but the script to do so
> does not support such kernels. How could I go about fixing this, so that the
> script supports other compression modes than just gzip?

Please test the patch from Dick Streefland at
https://bugzilla.kernel.org/show_bug.cgi?id=19852
and report how it works for you.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
