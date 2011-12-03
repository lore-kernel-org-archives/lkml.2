Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1LCSVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:21:13 -0500
Received: from mailfe05.c2i.net ([212.247.154.130]:46114 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753505Ab1LCSVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:21:11 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Dec 2011 13:21:11 EST
X-T2-Spam-Status: No, hits=-0.2 required=5.0 tests=ALL_TRUSTED,
	BAYES_50
From: Hans Petter Selasky <hselasky@c2i.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because of worrying about possible misusage?
Date: Sat, 3 Dec 2011 19:13:32 +0100
User-Agent: KMail/1.13.5 (FreeBSD/8.2-STABLE; KDE/4.4.5; amd64; ; )
Cc: VDR User <user.vdr@gmail.com>, Andreas Oberritter <obi@linuxtv.org>,
        HoP <jpetrous@gmail.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com> <20111203174247.0bbab100@lxorguk.ukuu.org.uk>
In-Reply-To: <20111203174247.0bbab100@lxorguk.ukuu.org.uk>
X-Face: *nPdTl_}RuAI6^PVpA02T?$%Xa^>@hE0uyUIoiha$pC:9TVgl.Oq,NwSZ4V"|LR.+tj}g5
	%V,x^qOs~mnU3]Gn;cQLv&.N>TrxmSFf+p6(30a/{)KUU!s}w\IhQBj}[g}bj0I3^glmC(
	:AuzV9:.hESm-x4h240C`9=w
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112031913.32503.hselasky@c2i.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some input from the sideline reading this discussion. As a FreeBSD'er I would 
very much like to see two things happen:

- vtunerc goes into userspace like a client/server daemon pair using CUSE and 
can support _any_ /dev/dvb/adapter, also those created by CUSE itself. That 
means I could potentially use vtunerc in FreeBSD with drivers like cx88:

http://corona.homeunix.net/cx88wiki

- DVB-X solution in Linux gets mmap support to avoid endless copying of data 
between kernel and userspace.

--HPS
