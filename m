Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2DXQZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:25:03 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58995 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755785Ab2DXQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:25:01 -0400
Message-ID: <4F96D3FA.1010909@xenotime.net>
Date: Tue, 24 Apr 2012 09:25:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 24 (kvm)
References: <20120424154354.7feba600beac616833d034de@canb.auug.org.au>
In-Reply-To: <20120424154354.7feba600beac616833d034de@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 10:43 PM, Stephen Rothwell wrote:

> Hi all,
> 
> There will probably be no linux-next release until April 30 as I am
> taking a break.
> 
> Changes since 20120423:


on i386:

  CC [M]  arch/x86/kvm/emulate.o
arch/x86/kvm/emulate.c: Assembler messages:
arch/x86/kvm/emulate.c:4122: Error: bad register name `%bpl'


-- 
~Randy
