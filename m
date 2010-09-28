Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0I1QIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:08:34 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36874 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab0I1QId convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 28 Sep 2010 12:08:33 -0400
Message-Id: <4CA22F1D020000780001961F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 28 Sep 2010 17:08:29 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Conny Seidel" <conny.seidel@amd.com>
Cc: "borislav.petkov@" <amd.com.borislav.petkov@amd.com>,
        "Andreas Herrmann3" <Andreas.Herrmann3@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: current TIP/master doesn't build on SLES10
References: <20100928163136.7a2355d0@marah.osrc.amd.com>
In-Reply-To: <20100928163136.7a2355d0@marah.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.09.10 at 16:31, Conny Seidel <conny.seidel@amd.com> wrote:
> Hi
> 
> compiling TIP/master (44bc8c4f500fce7263803b4acd016fa03cf8a91a) on
> SLES10 fails with the following build error:
> 
> arch/x86/kernel/entry_64.S: Assembler messages:
> arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments
> make[2]: *** [arch/x86/kernel/entry_64.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2
> make: *** [arch/x86] Error 2
> 
> I've bisected it to commit df5d1874ce1a1f0e0eceff4fa3a9d45620243a68.
> 
> Reverting it fixes the issue. 
> 
> I know that this is caused by binutils 2.16.91.0.5 which is distributed
> with SLES10.

I'm generally doing almost all of my work on SLE10, and have not run
into this issue. Are you sure you've got it fully updated?

Jan

