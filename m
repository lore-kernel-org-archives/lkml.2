Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab0EJMCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:02:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0EJMCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:02:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [RFC][PATCH resend 8/12] asm-generic: bitops: introduce le bit offset macro
Date: Mon, 10 May 2010 14:01:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, Avi Kivity <avi@redhat.com>,
       mtosatti@redhat.com, agraf@suse.de, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <201005061538.54326.arnd@arndb.de> <4BE7F22E.9070504@oss.ntt.co.jp>
In-Reply-To: <4BE7F22E.9070504@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005101401.52182.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX180Uw38AJc6KxunHT827Nb+7zvQyCTS4+u9me2
 sbg8xIQBIcnkPa+nxdrpzKaxLj/GsPezplT+c/a1VL3ZTUsXIo
 IBMbUKoTvSIz/jbiHb5/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 May 2010, Takuya Yoshikawa wrote:
> (2010/05/06 22:38), Arnd Bergmann wrote:
> > On Wednesday 05 May 2010, Takuya Yoshikawa wrote:
> >> There was a suggestion to propose set_le_bit_user() kind of macros.
> >> But what I thought was these have a constraint you two explained and seemed to be
> >> a little bit specific to some area, like KVM.
> >>
> >> So I decided to propose just the offset calculation macro.
> >
> > I'm not sure I understand how this macro is going to be used though.
> > If you are just using this in kernel space, that's fine, please go for
> > it.
> 
> Yes, I'm just using in kernel space: qemu has its own endian related helpers.
> 
> So if you allow us to place this macro in asm-generic/bitops/* it will help us.

No problem at all then. Thanks for the explanation.

Acked-by: Arnd Bergmann <arnd@arndb.de>
