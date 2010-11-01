Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0KAR5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:57:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42908 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0KAR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:57:40 -0400
Date: Mon, 1 Nov 2010 10:55:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2010-10-31-21-24 uploaded (mm/memcontrol)
Message-Id: <20101101105542.bf2ed97a.randy.dunlap@oracle.com>
In-Reply-To: <201011010427.oA14R3Y6010534@imap1.linux-foundation.org>
References: <201011010427.oA14R3Y6010534@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Oct 2010 21:25:59 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-10-31-21-24 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.36:


memcg-add-dirty-limits-to-mem_cgroup.patch

Something in mm/memcontrol.c::mem_cgroup_dirty_info()
does unsupported divisions on i386:

mm/built-in.o: In function `mem_cgroup_dirty_info':
(.text+0x58473): undefined reference to `__divdi3'
mm/built-in.o: In function `mem_cgroup_dirty_info':
(.text+0x584b1): undefined reference to `__divdi3'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
