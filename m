Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2FEPmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:42:25 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60238 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2FEPmY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 5 Jun 2012 11:42:24 -0400
Message-Id: <4FCE44FC0200007800088524@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 05 Jun 2012 16:42:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Don Zickus" <dzickus@redhat.com>
Cc: <x86@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
 <4FCDDB7D0200007800088390@nat28.tlf.novell.com>
 <20120605144734.GU32472@redhat.com>
In-Reply-To: <20120605144734.GU32472@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.06.12 at 16:47, Don Zickus <dzickus@redhat.com> wrote:
> On Tue, Jun 05, 2012 at 09:12:13AM +0100, Jan Beulich wrote:
>> So before applying a change like this, I'd really like to understand
>> the issue itself. Could you simply attach the nmi_selftest.o file
>> that you get without your patch here (and indicate which
>> upstream version or revision the corresponding source file was
>> from, to be able to re-construct what the compiler actually did)?
> 
> I could but it might be easier for you to re-create it on your end.
> Using gcc-4.4.4 on an x86_64 box and v3.5-rc1, I just set
> CONFIG_DEBUG_NMI_SELFTEST to 'y' and compile with
> 
> make ARCH=i386 O=out/i686
> 
> and it easily reproduces for me.

I don't think I have a plain 4.4.4 around anywhere, nor is it clear
whether you used a plain one (and how it was configured). For
tricky, highly version dependent things like this (where a compiler
bug also can't be excluded), having the _exact_ object file the
problem was seen with would be much easier than trying to hunt
down a compiler version that I can reproduce this with.

Jan

