Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab1FHBUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:20:08 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:35561 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab1FHBUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:20:06 -0400
Subject: Re: [PATCH 2/4] nohz: Split extended quiescent state handling from
 nohz switch
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>
In-Reply-To: <1307330437-15372-2-git-send-email-fweisbec@gmail.com>
References: <1307329858-14999-4-git-send-email-fweisbec@gmail.com>
	 <1307330437-15372-1-git-send-email-fweisbec@gmail.com>
	 <1307330437-15372-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Wed, 08 Jun 2011 09:15:47 +0800
Message-ID: <1307495747.2158.1.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For UniCore32 related code,

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks,

Guan Xuetao

