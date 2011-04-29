Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799Ab1D2QLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:11:04 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:45665 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759714Ab1D2QLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:11:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iU+nWmBdz7vCx0SwrntRX11mvvvMxIoDSEqc5fRd4JkKE9Dhjlv0oKPxLP+QgcPiLUzAnNqF78IHhXLD/5SFsbEYGUD16Pp9+ECgWogrld8VMesmnfiVxs7Othhk1ehC;
Date: Fri, 29 Apr 2011 09:10:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuiild@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 29 (uml build issue)
Message-Id: <20110429091058.d5d9fd54.rdunlap@xenotime.net>
In-Reply-To: <20110429131940.4f4c938f.sfr@canb.auug.org.au>
References: <20110429131940.4f4c938f.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 13:19:40 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110428:


My uml builds fail with:

  GEN     linux-next-20110429/UM64/Makefile
scripts/kconfig/conf --silentoldconfig arch/um/Kconfig.x86
  CC      arch/um/sys-x86_64/user-offsets.s
  GEN     linux-next-20110429/UM64/Makefile
linux-next-20110429/scripts/Makefile.asm-generic:9: linux-next-20110429/arch/um/include/asm/Kbuild: No such file or directory
make[2]: *** No rule to make target `linux-next-20110429/arch/um/include/asm/Kbuild'.  Stop.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
