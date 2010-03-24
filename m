Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0CXIc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:32:56 -0400
Received: from centrinvest.ru ([94.25.115.130]:49938 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab0CXIcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:32:54 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Wed, 24 Mar 2010 11:32:48 +0300
To: James Lamanna <jlamanna@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: SIIG DP CyberSerial 4S PCIe Support
Message-ID: <20100324083248.GA26485@centrinvest.ru>
Mail-Followup-To: James Lamanna <jlamanna@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Robert Hancock <hancockrwd@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
References: <aa4c40ff1003081107n78e9f052n2a754680e5491c68@mail.gmail.com>
 <aa4c40ff1003081313s7492513bk14a48c6097b90407@mail.gmail.com>
 <4B95B028.3050106@gmail.com>
 <aa4c40ff1003082115x3e9e1492je90e5afb826b3408@mail.gmail.com>
 <20100309141552.GD30538@centrinvest.ru>
 <8DFD46FA-A938-41D6-97EC-F6E5324C9FAA@gmail.com>
 <20100311134508.GB29239@centrinvest.ru>
 <20100318140630.f6768ee8.akpm@linux-foundation.org>
 <aa4c40ff1003191905v30b41899pc9ee07892fd56b97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa4c40ff1003191905v30b41899pc9ee07892fd56b97@mail.gmail.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 078, 03 19, 2010 at 07:05:38PM -0700, James Lamanna wrote:
> On Thu, Mar 18, 2010 at 2:06 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 11 Mar 2010 16:45:08 +0300
> > "Andrey Panin" <pazke@centrinvest.ru> wrote:
> >
> >> On 068, 03 09, 2010 at 07:09:21AM -0800, James Lamanna wrote:
> >> > On Mar 9, 2010, at 6:15, "Andrey Panin" <pazke@centrinvest.ru> wrote:
> >> >
> >> > >On 067, 03 08, 2010 at 09:15:26PM -0800, James Lamanna wrote:
> >> > >
> >> > >>That's probably the case.
> >> > >>It looks like 8250 doesn't know about this PCIe device at all.
> >> > >>The Oxford PCI ID is not in pci_ids.h nor is the SIIG subsystem ID.
> >> > >>I'll see if I can maybe work up a patch to support this device,
> >> > >>since I've found
> >> > >>the datasheet for the Oxford 4 port UART controller, but I may
> >> > >>need some help.
> >> > >>Or if anyone else (who has more experience with this) wants to
> >> > >>formulate one,
> >> > >>it would be greatly appreciated.
> >> > >
> >> > >Looks like you card can use existing code for Oxford Semiconductor
> >> > >UARTs.
> >> > >Can you test the attached patch for 2.6.33 ?
> >> >
> >> > Hi Andrey,
> >> > Coincidentally I found your patch for 2.6.28 that I was able to
> >> > backport to 2.6.24. The card seems to be working great!
> >> > Is this patch in mainline now?
> >>
> >> Now I'm confused, because I can't remember SIIG related patches for 2.6.28.
> >
> > I'm confused too. šIf someone had a patch which they think needs to be
> > applied, please resend it?
> 
> I believe this was the patch/diff that I saw:
> http://www.linuxhq.com/kernel/v2.6/28/drivers/serial/8250_pci.c

So you backported this patch and then applied my patch to get your card working ?
