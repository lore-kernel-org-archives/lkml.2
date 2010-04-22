Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0DVQTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:19:15 -0400
Received: from xenotime.net ([72.52.64.118]:45038 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751918Ab0DVQTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:19:14 -0400
Date: Thu, 22 Apr 2010 09:19:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: defconfig strangeness
Message-Id: <20100422091903.45f4bcb7.rdunlap@xenotime.net>
In-Reply-To: <20100422160723.GA13848@opentech.at>
References: <20100422160723.GA13848@opentech.at>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 18:07:23 +0200 Nicholas Mc Guire wrote:

> 
> HI !
> 
>  doing a series of static code analysis on 2.6.34-rcX each of them with 
>  defconfig (x86 32bit) - the strangeness is that even though the config
>  file is the same for rc3...5 the number of files actually compiled 
>  is very different. (linux-2.6 git tree)
> 
>  2.6.34-rc5 1695
>  2.6.34-rc4 3404
>  2.6.34-rc3 5109
> 
>  I diffed the .configs - rc4/rc5 only shows
> 
> 3,4c3,4
> < # Linux kernel version: 2.6.34-rc4
> < # Thu Apr 22 11:37:43 2010
> ---
> > # Linux kernel version: 2.6.34-rc5
> > # Thu Apr 22 10:44:02 2010
> 
>  why then this large difference in files being compiled ? 
> 
>  any hint apprecieated.

Just diff the build logs to see what is happening.

Or use 'make V=2' so that make will tell you why it's building each piece.

---
~Randy
