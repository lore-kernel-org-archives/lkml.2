Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2JWGzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:55:19 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:46317 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2JWGzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:55:17 -0400
Date: Tue, 23 Oct 2012 08:55:48 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.7-rc2
Message-ID: <20121023065548.GA4164@osiris.de.ibm.com>
References: <alpine.DEB.2.00.1210222146440.12209@ayla.of.borg>
 <CAMuHMdVS-qz0BAHXFGD01+w1GxyQ2M7DpLnLRQKtdZSiDfYgHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVS-qz0BAHXFGD01+w1GxyQ2M7DpLnLRQKtdZSiDfYgHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12102306-1948-0000-0000-00000348DFBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 09:50:26PM +0200, Geert Uytterhoeven wrote:
> On Mon, Oct 22, 2012 at 9:47 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > JFYI, when comparing v3.7-rc2 to v3.7-rc1[3], the summaries are:
> >   - build errors: +4/-44
> 
>   + arch/s390/include/asm/kvm_para.h: error: redefinition of
> 'kvm_arch_para_features':  => 147:28, 147:99
>   + arch/s390/include/asm/kvm_para.h: error: redefinition of
> 'kvm_check_and_clear_guest_paused':  => 152:91, 152:20
> 
> s390-allmodconfig/s390-allyesconfig/s390-defconfig

Thanks Geert. We have already a build fix for this from David Howells
which is waiting to be merged upstream.

