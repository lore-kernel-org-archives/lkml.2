Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1GVPxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:53:49 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:48606 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754584Ab1GVPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:53:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YGAfZ6Vtl2s0D/kA/yOfRSZI00ZMh18HsuFGPskDsykjr4FJiCJUsuRDsHch75sRypQ3vWUXcJCowhVqY37rJWnutX2I6LyWsy3mGh6ysHcbAnNivXG+7LqRQzQlLIbx;
Date: Fri, 22 Jul 2011 08:53:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Richard Weinberger <richard@nod.at>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 22 (uml)
Message-Id: <20110722085346.51565411.rdunlap@xenotime.net>
In-Reply-To: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au>
References: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 16:42:37 +1000 Stephen Rothwell wrote:

> Hi all,

uml build on i386 fails with:

arch/um/sys-i386/built-in.o: In function `call_rwsem_down_read_failed':
linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:93: undefined reference to `rwsem_down_read_failed'
arch/um/sys-i386/built-in.o: In function `call_rwsem_down_write_failed':
linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:105: undefined reference to `rwsem_down_write_failed'
arch/um/sys-i386/built-in.o: In function `call_rwsem_wake':
linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:118: undefined reference to `rwsem_wake'
arch/um/sys-i386/built-in.o: In function `call_rwsem_downgrade_wake':
linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:130: undefined reference to `rwsem_downgrade_wake'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
