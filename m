Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab2HJC6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:58:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49761 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760109Ab2HJC6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:58:37 -0400
Content-Type: text/plain; charset=gbk; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org
Date: Fri, 10 Aug 2012 10:57:08 +0800
Subject: compile a kernel for kgdb with less "optimized out"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: gaoqiang <gaoqiangscut@gmail.com>
Organization: qihoo
Message-ID: <op.wisztfmkn27o5l@gaoqiang-d1.corp.qihoo.net>
User-Agent: Opera Mail/12.01 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think those who use kgdb must hate this sentence  "optimized out". I  
have tried many times to build a kernel with less optimization but failed.  
today,I found a trick method ,just get rid of the -O2 and -Os on the top  
level of the kernel source and add -O2  for the  arch/x86 directory,it  
works !.I saw much "optimized out" now.

I build the kernel of centos6, with kernel 2.6.32. I don't know whether it  
works with kernel of other versions ,but it worth a try.
