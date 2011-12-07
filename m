Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab1LGSLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:11:12 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:37959 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757152Ab1LGSLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:11:10 -0500
Message-ID: <4EDFBA25.1020102@xenotime.net>
Date: Wed, 07 Dec 2011 11:10:29 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: Re: linux-next: Tree for Dec 7 (x86, not SMP)
References: <20111207171218.e11db78531e7f20659e2ca65@canb.auug.org.au>
In-Reply-To: <20111207171218.e11db78531e7f20659e2ca65@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 10:12 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20111206:


When CONFIG_SMP is not enabled:
(I think that's the cause, but it could be some other kconfig option.)


arch/x86/built-in.o: In function `test_nmi_ipi':
nmi_selftest.c:(.text+0xf7a0): undefined reference to `apic'

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
