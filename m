Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2FLNKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:10:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47542 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2FLNKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:10:20 -0400
Date: Tue, 12 Jun 2012 22:10:15 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        bhutchings@solarflare.com, grundler@parisc-linux.org, avi@redhat.com,
        mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/4] bitops: Introduce generic set_bit_le()
Message-Id: <20120612221015.53873334995f69573827c370@gmail.com>
In-Reply-To: <201206111410.26359.arnd@arndb.de>
References: <20120611212735.f92ea521.yoshikawa.takuya@oss.ntt.co.jp>
	<20120611213101.5969fde5.yoshikawa.takuya@oss.ntt.co.jp>
	<201206111410.26359.arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012 14:10:26 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 11 June 2012, Takuya Yoshikawa wrote:
> > From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> > 
> > Needed to replace test_and_set_bit_le() in virt/kvm/kvm_main.c which is
> > being used for this missing function.
> > 
> > Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> 
> I would recommend adding the corresponding clear_bit_le() along with
> set_bit_le, so the next person who needs that doesn't have to make
> yet another patch.

I will do in the next version.

Now I have also noticed that I need to add the same code to powerpc's
bitops file.

	Takuya
