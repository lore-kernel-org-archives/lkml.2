Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab2CGW4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:56:13 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:40572 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932372Ab2CGW4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:56:10 -0500
Message-ID: <4F57E791.6070205@xenotime.net>
Date: Wed, 07 Mar 2012 14:56:17 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 7 (kvm)
References: <20120307181009.bc377d39ae4f1d575305c693@canb.auug.org.au>
In-Reply-To: <20120307181009.bc377d39ae4f1d575305c693@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 11:10 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120306:
> 
> The kvm tree lost its build failure.


I'm getting this build error on X86_32 (i386):

arch/x86/kvm/x86.c:1042: Error: no instruction mnemonic suffix given and no register operands; can't size instruction


-- 
~Randy
