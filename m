Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0KSRLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:11:35 -0500
Received: from mail.selbetti.com.br ([201.67.157.50]:42731 "EHLO
	mail.selbetti.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0KSRLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:11:34 -0500
Subject: Re: Galbraith patch
From: Gilberto Nunes <gilberto.nunes@selbetti.com.br>
Reply-To: gilberto.nunes@selbetti.com.br
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: Gene Heskett <gene.heskett@gmail.com>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201011191749.14781.jordipujolp@gmail.com>
References: <201011191509.49586.jordipujolp@gmail.com>
	 <201011191005.12189.gene.heskett@gmail.com>
	 <201011191749.14781.jordipujolp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Selbetti =?ISO-8859-1?Q?Gest=E3o?= de Documentos
Date: Fri, 19 Nov 2010 15:11:24 -0200
Message-ID: <1290186684.3189.5.camel@note-311a>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI...

I have compile a kernel 2.6.36 with autogroup but I don't see
any /proc/sys/kernel/sched_autogroup_enabled

Also, I tried with noautogroup and autogroup on kernel line boot, but it
doesn't work...

Maybe I do samething wrong...




Em Sex, 2010-11-19 às 17:49 +0100, Jordi Pujol escreveu:
> A Divendres 19 Novembre 2010 16:05:12, Gene Heskett va escriure:
> > Thanks Jordi, but my last attempted build, using only the last 2 patches 
> > that Mike posted on a fresh unpack of 2.6.36, couldn't get past stage 2 of 
> > the modules build, it kept squawking about all the IR control stuff that
> > is  not even configured to be built.
> > 
> > I wonder how long it will take to get work this into mainline?
> > 
> > Along the same line, how does this compare to CK's bfs patch?
> 
> the autogroup-sched patch works well, right now writing this message from a 
> computer that runs that kernel.
> 
> this patch is much simpler than CK2, so I suppose that the implementation 
> should be more easy,
> I am trying both and observe, from my user's point of view, that they give a 
> similar result.
> 
> Gene, if that may help to do your own kernel implementation, the Debian kernel 
> sources I've used are available at:
> http://livenet.selfip.com/ftp/debian/linux-2.6/
> 
> 2.6.36 + CK2, in the subdirectory
>    linux-2.6.36-0.jpp.10-lnet/
> 2.6.36 + autogroup_sched, in the subdirectory
>    linux-2.6.36-0.jpp.11-lnet/
> 
> Jordi Pujol
> 
> Live never ending Tale
> GNU/Linux Live forever!
> http://livenet.selfip.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
--
Gilberto Nunes
Departamento de TI
Selbetti Gestão de Documentos
Fone: (47) 3441-6004
Celular (47) 8861-6672


<><

