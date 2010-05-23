Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0EWRx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 13:53:56 -0400
Received: from xenotime.net ([72.52.115.56]:44171 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754628Ab0EWRxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 13:53:55 -0400
Date: Sun, 23 May 2010 10:53:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: piotr@hosowicz.com
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
Message-Id: <20100523105347.8c4f8321.rdunlap@xenotime.net>
In-Reply-To: <4BF93392.7010803@example.com>
References: <4BF6F2E4.5030800@example.com>
	<20100521210729.GC2495@tuxdriver.com>
	<4BF6F959.5040401@example.com>
	<4BF6FBB0.6060407@example.com>
	<20100521151203.f94c1d3e.rdunlap@xenotime.net>
	<4BF7073A.4090506@example.com>
	<4BF7986C.4030505@example.com>
	<4BF7D185.2040705@example.com>
	<4BF7D86B.3020204@example.com>
	<4BF7DDAA.1080307@gmail.com>
	<4BF7DEE7.9010801@example.com>
	<4BF7DFDA.3000604@gmail.com>
	<4BF7E470.6080409@example.com>
	<4BF7E769.1090102@gmail.com>
	<4BF93392.7010803@example.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 May 2010 15:54:26 +0200 Piotr Hosowicz wrote:

> On 22.05.2010 16:17, Justin P. Mattock wrote:
> > On 05/22/2010 07:04 AM, Piotr Hosowicz wrote:
> >> On 22.05.2010 15:44, Justin P. Mattock wrote:
> >>
> >>> what about strace make
> >>> (maybe will give you info)
> >>
> >> May be I'll try like that if the problem persists. I will produce tons
> >> of output I believe :-(
> >>
> >
> >
> > yeah it does,
> > you can always send the
> > output to a file i.g.
> > strace -o filename make
> > anything at this point though
> > to see what is crapping out
> 
> I did not try it yet, but I update the source through git and tested:
> 
> make M=drivers/net/wireless modules
> 
> And they had built flawlessly. But main build with make-kpkg 
> kernel_image nevertheless still fails. I don;t know what to do. I don't 
> want to do those strace's, because it will take awfully long.

Sorry, I still don't see the primary error message.

Maybe you can post to a Debian mailing list or search their archives
to see if this is already known or fixed?

Or see what error code 2 from make-kpkg means, if possible.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
