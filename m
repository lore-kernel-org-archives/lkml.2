Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0IVP0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:26:08 -0400
Received: from xenon13.um.es ([155.54.212.167]:44452 "EHLO xenon13.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab0IVP0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:26:07 -0400
Subject: Re: CFQ I/O scheduler better than AS?
From: Juan PC <piernas@ditec.um.es>
To: diegocg@gmail.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <201009221410.17056.diegocg@gmail.com>
References: <1285152908.10774.306.camel@albahaca.inf.um.es>
	 <201009221410.17056.diegocg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 17:26:00 +0200
Message-Id: <1285169160.10774.317.camel@albahaca.inf.um.es>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Diego,

El mié, 22-09-2010 a las 14:10 +0200, Diego Calleja escribió:
> On Miércoles, 22 de Septiembre de 2010 12:55:08 Juan PC escribió:
> > Hi:
> > 
> > I am sure that, for most people, the clear answer is "yes" (after all,
> > CFQ is the default I/O scheduler in Linux), but we are having serious
> > difficulties to find a benchmark which shows that CFQ is undoubtedly
> > better than AS.
> 
> The AS io scheduler was removed in 2.6.33 (7 months ago, in commit 
> 492af6350a5ccf087e4964104a276ed358811458), so you must be running
> benchmarks in old kernels. The CFQ scheduler used in recent kernels
> should have good performance (if it doesn't, you probably should
> write a bug report ccing jens.axboe@oracle.com)
> 
Well, 2.6.30/31 are not so old ;-)

However, this fact reinforces my question. I guess that AS was removed
due to a good reason, probably, some benchmark results. If so, those are
the benchmarks I am looking for. Do you know their names?

Thanks in advance!

	Juan

PD: BTW, congratulations for your D'Oh blog ;-)

> Saludos ;)
-- 
D. Juan Piernas Cánovas
Departamento de Ingeniería y Tecnología de Computadores
Facultad de Informática. Universidad de Murcia
Campus de Espinardo - 30080 Murcia (SPAIN)
Tel.: +34868887657    Fax: +34868884151
email: piernas@ditec.um.es
PGP public key:
http://pgp.rediris.es:11371/pks/lookup?search=piernas%
40ditec.um.es&op=index

*** Por favor, envíeme sus documentos en formato texto, HTML, PDF o
PostScript :-) ***
You have new mail in /var/spool/mail/piernas


