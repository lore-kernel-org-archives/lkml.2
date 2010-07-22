Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0GVR5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:57:32 -0400
Received: from web100105.mail.kks.yahoo.co.jp ([114.111.99.80]:24105 "HELO
	web100105.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751462Ab0GVR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:57:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=UgXGR/qBpjAa5YG2cLb9F4yq4NOh/KfmdU150lhM9CK2bjrovm07IZr+4lspBe5FbPai5fJ0AIXdjRjzMljzb8HkmcOp+T4tK/KsihxbkbYrSTKkxO/dAnic37TNnaSp  ;
Message-ID: <20100722175727.43642.qmail@web100105.mail.kks.yahoo.co.jp>
Date: Fri, 23 Jul 2010 02:57:27 +0900 (JST)
From: tanaka <tanaka_hideo@yahoo.co.jp>
Subject: Re: Please teach me X86 I/O port 0x61
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100715090746.fdfce533.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good evening. Dear all.

I appreciate your responses.
We use AMD CPU machine.

For example,
http://www.sun.com/servers/entry/x4100/arch-wp.pdf

In Figure 1-1 block diagram (page 10) ,
which device is mapped 0x61 address in ?

--- Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 16 Jul 2010 00:00:36 +0900 (JST) tanaka wrote:
> 
> > Dear all.
> > 
> > I investigate about  NMI kernel messages.
> > Linux kernel read 0x61 address using inb(61h).
> > 
> > I search a amd opteron cpu following manuals.
> > but I do not find  explanation of 0x61 address.
> > 
> >
>
http://support.amd.com/us/psearch/Pages/psearch.aspx?type=2.1&product=2.1.4&contentType=Tech+Doc+Processor&ostype=&keywords=&items=20
> > 
> > Could you teach me a 0x61 address of X86 arch >
> 
> Hi,
> 
> IO port 0x61 (NMI Status & Control register) is not CPU-specific on
> x86.
> It's more of a platform thing.
> 
> Intel describes it in ICH (chipset) specs, e.g., ICH7 spec,
> section 10.7.1.  Please try that and see if it answers your
> questions.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your
> code ***
> --



--------------------------------------
Get the new Internet Explorer 8 optimized for Yahoo! JAPAN
http://pr.mail.yahoo.co.jp/ie8/
