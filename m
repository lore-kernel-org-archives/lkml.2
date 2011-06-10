Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab1FJMr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:47:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab1FJMr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:47:26 -0400
Message-ID: <4DF21254.6090106@redhat.com>
Date: Fri, 10 Jun 2011 09:47:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 8 (docbook/media)
References: <20110608161046.4ad95776.sfr@canb.auug.org.au> <20110608125243.e63a07fc.randy.dunlap@oracle.com> <4DF11E15.5030907@infradead.org> <4DF12263.3070900@redhat.com> <4DF12DD1.7060606@oracle.com> <4DF1581E.8050308@redhat.com> <4DF1593A.6080306@oracle.com>
In-Reply-To: <4DF1593A.6080306@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Em 09-06-2011 20:37, Randy Dunlap escreveu:
> 
> Big hint:  I see these errors not during "make htmldocs" but during a kernel code build
> when CONFIG_BUILD_DOCSRC=y.
> 
> Sorry, I should have mentioned this earlier.

I couldn't reach any troubles there. Documentation build is stopping earlier.
I'm using the -next tree for 20110610:

$ make defconfig
$ make CONFIG_BUILD_DOCSRC=y -j 16 Documentation/

Documentation/networking/timestamping/timestamping.c:45:30: error: linux/net_tstamp.h: No such file or directory
Documentation/networking/timestamping/timestamping.c: In function ‘main’:
Documentation/networking/timestamping/timestamping.c:331: error: storage size of ‘hwconfig’ isn’t known
Documentation/networking/timestamping/timestamping.c:331: error: storage size of ‘hwconfig_requested’ isn’t known
Documentation/networking/timestamping/timestamping.c:355: error: ‘SOF_TIMESTAMPING_TX_HARDWARE’ undeclared (first use in this function)
Documentation/networking/timestamping/timestamping.c:355: error: (Each undeclared identifier is reported only once
Documentation/networking/timestamping/timestamping.c:355: error: for each function it appears in.)
Documentation/networking/timestamping/timestamping.c:357: error: ‘SOF_TIMESTAMPING_TX_SOFTWARE’ undeclared (first use in this function)
Documentation/networking/timestamping/timestamping.c:359: error: ‘SOF_TIMESTAMPING_RX_HARDWARE’ undeclared (first use in this function)
Documentation/networking/timestamping/timestamping.c:361: error: ‘SOF_TIMESTAMPING_RX_SOFTWARE’ undeclared (first use in this function)
Documentation/networking/timestamping/timestamping.c:363: error: ‘SOF_TIMESTAMPING_SOFTWARE’ undeclared (first use in this function)
Documentation/accounting/getdelays.c: In function ‘main’:
Documentation/networking/timestamping/timestamping.c:365: error: ‘SOF_TIMESTAMPING_SYS_HARDWARE’ undeclared (first use in this function)Documentation/accounting/getdelays.c:525: error: ‘TASKSTATS_TYPE_NULL’ undeclared (first use in this function)

Documentation/accounting/getdelays.c:525: error: (Each undeclared identifier is reported only once
Documentation/accounting/getdelays.c:525: error: for each function it appears in.)
Documentation/networking/timestamping/timestamping.c:367: error: ‘SOF_TIMESTAMPING_RAW_HARDWARE’ undeclared (first use in this function)
Documentation/networking/timestamping/timestamping.c:387: error: ‘HWTSTAMP_TX_ON’ undeclared (first use in this function)
Documentation/networking/timestamping/timestamping.c:387: error: ‘HWTSTAMP_TX_OFF’ undeclared (first use in this function)
Documentation/networking/timestamping/timestamping.c:390: error: ‘HWTSTAMP_FILTER_PTP_V1_L4_SYNC’ undeclared (first use in this function)
Documentation/networking/timestamping/timestamping.c:390: error: ‘HWTSTAMP_FILTER_NONE’ undeclared (first use in this function)
Documentation/networking/timestamping/timestamping.c:331: warning: unused variable ‘hwconfig_requested’
Documentation/networking/timestamping/timestamping.c:331: warning: unused variable ‘hwconfig’
make[2]: *** [Documentation/accounting/getdelays] Error 1
make[3]: *** [Documentation/networking/timestamping/timestamping] Error 1
make[1]: *** [Documentation/accounting] Error 2
make[1]: *** Waiting for unfinished jobs....
make[2]: *** [Documentation/networking/timestamping] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [Documentation/networking] Error 2
make: *** [Documentation/] Error 2

Could you please send me your .config?

Thanks,
Mauro
