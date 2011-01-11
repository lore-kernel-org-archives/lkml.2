Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1AKBkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:40:20 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:49084 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab1AKBkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:40:15 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Sam Ravnborg'" <sam@ravnborg.org>
Cc: "'lkml'" <linux-kernel@vger.kernel.org>,
        "'linux-kbuild'" <linux-kbuild@vger.kernel.org>,
        "'linux arch'" <linux-arch@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Michal Marek'" <mmarek@suse.cz>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110109192707.GA12387@merkur.ravnborg.org> <20110109192907.GA12403@merkur.ravnborg.org> <004e01cbb0c8$4de80470$e9b80d50$@mprc.pku.edu.cn> <20110110162639.GB13763@merkur.ravnborg.org>
In-Reply-To: <20110110162639.GB13763@merkur.ravnborg.org>
Subject: RE: [PATCH 1/2] kbuild: asm-generic support
Date: Tue, 11 Jan 2011 09:39:49 +0800
Message-ID: <005b01cbb130$712f8f80$538eae80$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIVRfr/5g4pH+HCwkBSapEbzIVlUQFFgFFvAdGKISMCRnkFIwGfH0RXkv/r8PA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sam Ravnborg [mailto:sam@ravnborg.org]
> Sent: Tuesday, January 11, 2011 12:27 AM
> To: Guan Xuetao
> Cc: 'lkml'; 'linux-kbuild'; 'linux arch'; 'Arnd Bergmann'; 'Michal Marek'
> Subject: Re: [PATCH 1/2] kbuild: asm-generic support
> 
> Hi Guan (I will try to spell you name correct fom now on!)
Thanks.
> 
> > > +	During the prepare phase of the build a wrapper include
> > > +	file is generated in the directory:
> > > +
> > > +		arch/$(ARCH)/include/generated/asm
> > IMHO, the directory could be include/generated/asm
> 
> We have moved all the arch specific files away from include/*
> which is why I invented arch/$(ARCH)/include/generated.
> 
> I was actually considering:
> 
>    arch/$(ARCH)/generated.
> 
> But using include/generated just seems wrong.
The generated headers is just the wrapper of asm-generic headers, so it's
more the interface than the arch specific files.
Using include/generated avoids two generated header dirs, and simplifies
the thought and handler. 

Guan Xuetao

