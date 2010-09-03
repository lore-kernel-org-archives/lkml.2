Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0ICIzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:55:31 -0400
Received: from verein.lst.de ([213.95.11.210]:38263 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab0ICIza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:55:30 -0400
Date: Fri, 3 Sep 2010 10:55:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Arnaud Patard <apatard@mandriva.com>
Cc: Christoph Hellwig <hch@lst.de>, Bernhard Walle <walle@corscience.de>,
        linux-mips@linux-mips.org, ralf@linux-mips.org,
        ddaney@caviumnetworks.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: N32: Fix getdents64 syscall for n32
Message-ID: <20100903085521.GA304@lst.de>
References: <1283501734-6532-1-git-send-email-walle@corscience.de> <20100903084213.GA32339@lst.de> <m3pqwvb438.fsf@anduin.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3pqwvb438.fsf@anduin.mandriva.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 10:53:31AM +0200, Arnaud Patard wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> Hi,
> 
> > I'm not sure why people suddenly started Ccing me on utterly random
> > patches, but could you guys please bloody stop it?  Thanks!
> 
> I guess the explanation is the one below :
> 
> $ ./scripts/get_maintainer.pl -f arch/mips/kernel/scall64-n32.S

I'm certainly not the maintainer of it, nor anything near it.  Whoever
wrote such a stupid script really needs to be beaten up seriously.

