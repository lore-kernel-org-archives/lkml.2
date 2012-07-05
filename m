Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab2GEPbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:31:01 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:57619
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756707Ab2GEPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:30:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz98dIzz1202h1082kzzz2dh2a8h668h839hd25he5bhf0ah107ah)
Message-ID: <4FF5B329.9090005@freescale.com>
Date: Thu, 5 Jul 2012 10:30:49 -0500
From: Timur Tabi <b04825@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>, <leoli@freescale.com>
Subject: Re: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
References: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com> <CAOZdJXUeY-_mmBLoA25_g4eLqwHxYX4c_ECbU+KYqfM307THNQ@mail.gmail.com> <20120704031426.GA6133@localhost.localdomain> <4FF3B5B6.8090400@freescale.com> <20120704034545.GA6196@localhost.localdomain> <4FF45F19.2080607@freescale.com> <20120705102529.GA7982@localhost.localdomain>
In-Reply-To: <20120705102529.GA7982@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhao Chenhui wrote:
> If the guts node is missing, this code snippet will be skipped. If the guts node is existed,
> the return value of of_iomap(), namely guts, will be tested. If it is NULL, it shows
> that there is error in dts, or the ioremap() in of_iomap() failed. I think
> these errors are fatal errors, so I print an error info and return.

Ok, I see your point now.  I'm concerned about what might happen if
someone else updates mpc85xx_smp_init() in the future, but there's nothing
actually wrong with your patch today.

-- 
Timur Tabi
Linux kernel developer at Freescale

