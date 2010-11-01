Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0KANBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:01:06 -0400
Received: from lo.gmane.org ([80.91.229.12]:35412 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570Ab0KANAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:00:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el.es.cr@gmail.com>
Subject: Re: [PATCH] Optimize =?utf-8?b?cmVsYXlfYWxsb2NfcGFnZV9hcnJheSgp?= slightly by using vzalloc rather than vmalloc and memset
Date: Mon, 1 Nov 2010 13:00:28 +0000 (UTC)
Message-ID: <loom.20101101T135727-603@post.gmane.org>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net> <20101030214704.GA20005@Krystal> <alpine.LNX.2.00.1010302343590.1572@swampdragon.chaosbits.net> <20101031183913.GA26160@Krystal> <20101101122237.GM6023@cr0.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 217.36.116.105 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong <at> gmail.com> writes:


> That compiler would be broken if it exists. Also, I doubt linux kernel
> could be compiled with other compilers than gcc (except icc?).
> 

Not longer than a few days ago, somebody from llvm claimed he got it compiling
the kernel, and also that he got it self-hosting, on bare metal and in virtual
box (virtual box <> VirtualBox, lol)

el es

