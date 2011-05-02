Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1EBPTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:19:54 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:40293 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757510Ab1EBPTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:19:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kNjbDBwc3JDsrxuM5ygvhUIci4FK7YOIljZkkZmGSj2sP4nevsQBGMjpQH+1BJIXqTQPeoc1qXbi+AxUtekKyU+aNvO5rJKXnQlh2w4yIhcOmPltQpp6OPAf6iXSeoc1;
Date: Mon, 2 May 2011 08:19:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuild@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, sam@ravnborg.org
Subject: Re: linux-next: Tree for May 2 (uml builds fail)
Message-Id: <20110502081948.1ccb9aef.rdunlap@xenotime.net>
In-Reply-To: <20110502150150.d932642f.sfr@canb.auug.org.au>
References: <20110502150150.d932642f.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011 15:01:50 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110429:


uml builds on i386 or x86_64 fail with: (I'm using O=outputdir if it matters)

  GEN     /lnx/src/NEXT/linux-next-20110502/UM64/Makefile
scripts/kconfig/conf --silentoldconfig arch/um/Kconfig.x86
  GEN     /lnx/src/NEXT/linux-next-20110502/UM64/Makefile
/lnx/src/NEXT/linux-next-20110502/scripts/Makefile.asm-generic:9: /lnx/src/NEXT/linux-next-20110502/arch/um/include/asm/Kbuild: No such file or directory
make[2]: *** No rule to make target `/lnx/src/NEXT/linux-next-20110502/arch/um/include/asm/Kbuild'.  Stop.



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
