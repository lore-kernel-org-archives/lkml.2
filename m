Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1EUP1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 11:27:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab1EUP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 11:27:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: X32 project status update
Date: Sat, 21 May 2011 17:27:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com,
        "H. Peter Anvin" <h.peter.anvin@intel.com>
References: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
In-Reply-To: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211727.35985.arnd@arndb.de>
X-Provags-ID: V02:K0:TfZi+Bfl8dbFtRpFcWUBTdObynB5wEPUKOHwTLhjRuA
 8orcjHqZxOBk+6kXobv0yMC9ng8Fabj+nFlZLuL1j+/OXJ7ov9
 0PV0s/4JowAEj0S239xLHWgSYZ1jW7CptLFR1V1fEZCSWwIC26
 J/uPS/Dw4XPZsg5CRcPEhxqzw6Iuj175T9K+KwrhEXwY5DT17r
 5oY8MH6vGeXOdFej+L6OA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 May 2011 17:01:33 H.J. Lu wrote:
> This is the x32 project status update:
> 
> https://sites.google.com/site/x32abi/
> 

I've had another look at the kernel patch. It basically
looks all good, but the system call table appears to
diverge from the x86_64 list for no (documented) reason,
in the calls above 302. Is that intentional?

I can see why you might want to keep the numbers identical,
but if they are already different, why not use the generic
system call table from asm-generic/unistd.h for the new
ABI?

	Arnd
