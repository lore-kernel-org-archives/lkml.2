Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0LLTR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:17:26 -0500
Received: from mail.anarazel.de ([217.115.131.40]:45684 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab0LLTRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:17:25 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 14:17:25 EST
From: Andres Freund <andres@anarazel.de>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Subject: Re: Costly Context Switches
Date: Sun, 12 Dec 2010 20:07:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-andres-00006-g4193d91; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20101212151112.GE26583@charite.de>
In-Reply-To: <20101212151112.GE26583@charite.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012122007.07372.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 December 2010 16:11:12 Ralf Hildebrandt wrote:
> I recently made a parallel installation of dovecot-2.0 on my mailbox
> server, which is running dovecot-1.2 without any problems whatsoever.
> 
> Using dovecot-2.0 on the same hardware, same kernel, with the same users
> and same mailboxes and usage behaviour results in an immense increase in
> the load numbers.
> 
> Switching back to 1.2 results in a immediate decrease of the load back
> to "normal" numbers.
> 
> This is mainly due to a 10-20 fold increase of the number of context
> switches. The same problem has been reported independently by Cor
> Bosman of XS4All, on different hardware (64bit instead of 32bit, real
> hardware instead of virtual hardware).
> 
> So, now the kernel related question: How can I find out WHY the
> context switches are happening? Are there any "in kernel" statistics I
> could look at?
"strace" or "perf trace syscall-counts" would be a good start.

Andres
