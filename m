Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab0KPTdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:33:02 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36119 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422Ab0KPTdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:00 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 16 Nov 2010 13:32:40 -0600
Subject: RE: [RFC][PATCH v2] irq_work: Drop cmpxchg result
Thread-Topic: [RFC][PATCH v2] irq_work: Drop cmpxchg result
Thread-Index: AcuFunXNzOKybXOcQqiI9jXmFG+5PwACmAbQ
Message-ID: <A24693684029E5489D1D202277BE89447382A71F@dlee02.ent.ti.com>
References: <1289930567-17828-1-git-send-email-saaguirre@ti.com>
 <1289931413.5372.509.camel@edumazet-laptop>
In-Reply-To: <1289931413.5372.509.camel@edumazet-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> Sent: Tuesday, November 16, 2010 12:17 PM
> To: Aguirre, Sergio
> Cc: LKML; Huang Ying; Martin Schwidefsky; Ingo Molnar; Kyle McMartin;
> Peter Zijlstra
> Subject: Re: [RFC][PATCH v2] irq_work: Drop cmpxchg result
> 
> Le mardi 16 novembre 2010 à 12:02 -0600, Sergio Aguirre a écrit :
> > This solves this compilation warning:
> >
> > kernel/irq_work.c: In function 'irq_work_run':
> > kernel/irq_work.c:148: warning: value computed is not used
> 
> Just curious, what is your compiler version ?

I'm using a Code Sourcery ARM toolchain, and compiling for TI OMAP2+ chips (armv7-a)

# arm-none-linux-gnueabi-gcc --version
arm-none-linux-gnueabi-gcc (Sourcery G++ Lite 2010q1-202) 4.4.1
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Regards,
Sergio

> 
> Thanks
> 

