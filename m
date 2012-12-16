Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab2LPB2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 20:28:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57443 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2LPB2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 20:28:18 -0500
Date: Sun, 16 Dec 2012 01:28:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: /usr/include/linux/errno.h:1:23: fatal error: asm/errno.h: No
 such file or directory
Message-ID: <20121216012816.GZ4939@ZenIV.linux.org.uk>
References: <CAAJw_ZueeeNwCGnQD75=AcNwLxWBM3hEvq3LYXEiMcz4Sibk-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAJw_ZueeeNwCGnQD75=AcNwLxWBM3hEvq3LYXEiMcz4Sibk-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 09:23:38AM +0800, Jeff Chua wrote:
> How should the symbolic links be setup to compile the latest kernel?
> 
> 
> Currently I had these links and kernels compiled fine until 2 days ago.
> 
>          asm -> /usr/src/linux/include/uapi/asm-generic/
>          asm-generic -> /usr/src/linux/include/uapi/asm-generic
>          linux -> /usr/src/linux/include/uapi/linux

What symlinks?  /usr/include/* should not contain any symlinks into
the kernel source.  At all.
