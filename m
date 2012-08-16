Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2HPMiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:38:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64154 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2HPMiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:38:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/31] arm64: Exception handling
Date: Thu, 16 Aug 2012 11:54:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208151303.47743.arnd@arndb.de> <20120816100536.GF31784@mudshark.cambridge.arm.com>
In-Reply-To: <20120816100536.GF31784@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208161154.10891.arnd@arndb.de>
X-Provags-ID: V02:K0:xkfkbV3K/R6dzvDGcj+4UkLz4pBa0LwUBBwDGykBgR0
 AOT9ZE00H1GM6xRfYSTtRz5CBbAiuYysvS+IAoZIZw1fzj7/q8
 AmWcBjvQ00QlrQbymhibZHYFrpsQvzjXWCcLamiWt/2hjeQOLa
 z5Zpz5cYAJcBkjVqApmnXY4yjb+L2rbZFdFsY/oIWV5cPdA8Q5
 VaUzIgBPcFC9E9SqeaywrQ7gH9jqf2qO5fqTXBIelymU7vnuMS
 YIpktpeGud5d5Eo/Yi9PICBAENM8GVLfJIN5SHY6s1wRj1leQh
 18W3TOKdwp3FYZmG+x8KHV/Rir0j4etohFHdC3j7Q0rZYPUW0M
 YeEe3/h0FrD9biJVakzI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Will Deacon wrote:
> On Wed, Aug 15, 2012 at 02:03:47PM +0100, Arnd Bergmann wrote:
> > On Tuesday 14 August 2012, Catalin Marinas wrote:
> > 
> > > +#ifdef CONFIG_AARCH32_EMULATION
> > > +#define compat_thumb_mode(regs) \
> > > +   (((regs)->pstate & COMPAT_PSR_T_BIT))
> > > +#else
> > > +#define compat_thumb_mode(regs) (0)
> > > +#endif
> > 
> > The symbol we use on other platforms is CONFIG_COMPAT. I don't think you
> > need to have a separate CONFIG_AARCH32_EMULATION
> 
> Using COMPAT does preclude the possibility of doing something like the x32
> ABI later on though. Some other architectures seem to do something similar
> (MIPS32_COMPAT, IA32_EMULATION).

Ok, fair enough.

	Arnd

