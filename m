Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab1DALu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:50:57 -0400
Received: from lo.gmane.org ([80.91.229.12]:46325 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab1DALuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:50:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lukasz <el.es.cr@gmail.com>
Subject: FPC headers for Linux Kernel
Date: Fri, 1 Apr 2011 11:50:34 +0000 (UTC)
Message-ID: <loom.20110401T125740-650@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.148.39.235 (Mozilla/5.0 (Windows NT 5.1; rv:2.0) Gecko/20100101 Firefox/4.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi LKML,


(apologies for weird looking justifications, gmane makes people
manually cut their lines at 80 chars)

Everybody knows programming kernel modules is fun, except for the 
less-than-cool compiler choice.

Enter FPC, the Free Pascal Compiler.
It's been around for a long time, actually it may be about same age
as the Linux Kernel.

It is cross-platform and it isn't yet another gcc frontend.

With some free time, some time ago, I set out to look whether
somebody has ever tried to write and compile a kernel module with it,
that actually does _something_
And I found this : 
http://wiki.freepascal.org/linux/kernel/module_development

The original part (before the 'for fun' addition) was by Mazen Neifer,
but his example was a tit-for-tot cut&paste&translate from some 
example c module code. Which didn't want to work on my relatively 
newer stable kernel (on Ubuntu Lucid) because some symbols were 
undefined (moved inline or something).

Therefore I thought I want to start from basics, and went on with
printk() first. That succeeded.

On the way it emerged that some of OP's description was outdated, 
so I added my own text & descriptions to FPC wiki.

And so http://wiki.freepascal.org/linux/kernel
/module_development#Building_kernel_modules_.28for_fun.29_thread
was born. (please copy/paste this link together)

And here we are.
This project is for fun. I haven't found the time to push it to
any git repo yet, and also it is currently only tested on the
moss-covered stable version of Kernel.
In fact I barely got past uploading it to the wiki, and starting
about with a github account for it, when I was deprived of most
of the free for-fun time again. But I am willing to push this 
forward somewhere in the future.

Time-allowing, I'd like to create/translate minimum usable set
of headers that will allow out-of-tree kernel modules (BUT still
GPL'd as per kernel license!) be compiled with FPC.
As can be seen, printk() works with any form of invoking it, already.
But that is trivial stuff.

Why use stable kernel, you may ask, and additionally, that old ?
Because, it has to start from something well defined, and unchanging.
It is very microscopic and 'beginners job' at the moment. 

Because it is supposed to work on inside of the kernel, where 
internal interfaces are supposed to be hacked about, until release,
but do not really change between releases.

Because I am too lazy to compile my own kernels and I rely on 
a distro to do it for me.

Because I am aware of people using FPC already to create and compile
native Android applications. FPC supports wide variety of
supported platforms already.

And I don't mean this as 'another way of putting binary blobs into
kernel', because the headers will be strictly GPL.

Short and to the point: I hope people interested will have as much
fun as I have, digging this ;)

Hopefully, it may be interesting.

Have fun,
Lukasz


