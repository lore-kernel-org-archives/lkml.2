Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab1HSHKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:10:42 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24111 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab1HSHKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:10:41 -0400
Date: Fri, 19 Aug 2011 09:11:11 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Amirali Shambayati <amirali.shambayati@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Subject: Re: Is it needed to reinstall custom kernel every time, after
 rebuilding?
In-Reply-To: <CAC-yRPShbCYgBiruVQATv8+yqJzaaMGS3skFQe6Gv-KrXKsHXA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1108190910281.31857@swampdragon.chaosbits.net>
References: <CAC-yRPShbCYgBiruVQATv8+yqJzaaMGS3skFQe6Gv-KrXKsHXA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, Amirali Shambayati wrote:

> Hi all,
> 
> Last time, I emailed to linux-kernel and kernenewbies mailing-lists
> about how to speed up kernel compilation. I received very useful peace
> of advice about using "ccache". Now I want to modify and compile a
> unique custom kernel several times.
> I used https://help.ubuntu.com/community/Kernel/Compile to compile
> custom kernel. This tutorial uses "kpkg" command to build kernel and
> it produces two .deb files: "linux-image" and "linux-header" as
> result.
> So for the first time I followed this tutorial.
> For next times, according to to experts' advice, I use "make all" in
> custom kernel root directory to rebuild kernel. I am not sure that it
> would be enough to use changed kernel after rebooting. As I asked from
> some experts, It is also required to install kernel again, but they
> were not familiar with "kpkg" and "dbkg",... commands for kernel
> installation.
> Should I use "dbkg" command after every time I rebuild kernel, for
> re-installation?
> If anybody is familiar with these method of kernel installation,
> please help me. It is very urgent, because it is related to my B.S.
> thesis :P
> 

If you build a new kernel and want to run that new kernel, then you must 
install that newly build kernel and reboot to it.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

