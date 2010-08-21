Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab0HUVAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 17:00:47 -0400
Received: from xenotime.net ([72.52.115.56]:55122 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751010Ab0HUVAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 17:00:45 -0400
Date: Sat, 21 Aug 2010 10:27:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: runcoderen <runcoderzhcn@gmail.com>
Message-Id: <20100821102752.2486c864.rdunlap@xenotime.net>
In-Reply-To: <1282351937.1631.22.camel@bencharluo-laptop>
References: <1282347657.1631.16.camel@bencharluo-laptop>
	<20100820174833.f89bb352.rdunlap@xenotime.net>
	<1282351937.1631.22.camel@bencharluo-laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: version.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Aug 2010 08:52:17 +0800 runcoderen wrote:

> hi Randy:
> but I donwload linux kernel source code version is 2.6.10

Yep, my bad.  In all of 2.6, version.h is a generated file.
(The trees where I found it were not clean, i.e., they already contained
the generated file.)


> 在 2010-08-20五的 17:48 -0700，Randy Dunlap写道：
> > On Sat, 21 Aug 2010 07:40:57 +0800 runcoderen wrote:
> > 
> > > hi all:
> > > the LDD 3rd edition is based on linux-2.6.10.
> > > Thus I downloaded the special kernel code.
> > > 
> > > but it can't find the version.h file.
> > > 
> > > the path I try to find is linux-2.6.10/include/linux
> > > -- 
> > 
> > Hi,
> > 
> > Since linux 2.6.25, include/linux/version.h is a generated file.
> > I.e., it is produced at kernel make/build time.
> > 
> > 2.6.24 and before do have include/linux/version.h.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
