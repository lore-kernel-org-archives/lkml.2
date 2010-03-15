Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965190Ab0COPVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:21:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42776 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965070Ab0COPVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:21:00 -0400
Message-ID: <4B9E4EB1.9010800@zytor.com>
Date: Mon, 15 Mar 2010 08:13:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com, drepper@redhat.com,
       torvalds@linux-foundation.org, munroesj@linux.vnet.ibm.com
Subject: Re: 64-syscall args on 32-bit vs syscall()
References: <1268628493.2355.2.camel@pasglop> <20100314.220646.190065794.davem@davemloft.net> <1268630313.2335.2.camel@pasglop> <20100315134449.GB1653@linux-mips.org>
In-Reply-To: <20100315134449.GB1653@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 06:44 AM, Ralf Baechle wrote:
> 
> Syscall is most often used for new syscalls that have no syscall stub in
> glibc yet, so the user of syscall() encodes this ABI knowledge.  If at a
> later stage syscall() is changed to have this sort of knowledge we break
> the API.  This is something only the kernel can get right.
> 

One option would be to do a libkernel.so, with auto-generated stubs out
of the kernel build tree.  As already discussed in #kernel this morning,
there are a number of sticky points with types and namespaces for this
this, but those aren't any worse than the equivalent problems for
syscall(3).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

