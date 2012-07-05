Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2GERL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:11:28 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:40830
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910Ab2GERL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:11:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh2a8h668h839h93fhd25he5bhf0ah107ah)
Message-ID: <4FF5CAB5.5090904@freescale.com>
Date: Thu, 5 Jul 2012 12:11:17 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: Tabi Timur-B04825 <B04825@freescale.com>,
        Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>, <leoli@freescale.com>
Subject: Re: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
References: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com> <CAOZdJXUeY-_mmBLoA25_g4eLqwHxYX4c_ECbU+KYqfM307THNQ@mail.gmail.com> <20120704031426.GA6133@localhost.localdomain> <4FF3B5B6.8090400@freescale.com> <20120704034545.GA6196@localhost.localdomain>
In-Reply-To: <20120704034545.GA6196@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 10:45 PM, Zhao Chenhui wrote:
> On Tue, Jul 03, 2012 at 10:17:12PM -0500, Tabi Timur-B04825 wrote:
>> Zhao Chenhui wrote:
>>> If the guts variable is NULL, it indicates there is error in dts or kernel.
>>> We should fix the error, rather than ignore it.
>>
>> And that's why there's a warning message.  Crashing the kernel is not 
>> going to fix anything.
>>
> 
> This error likely crashes the kenel somewhere.

Only if you're doing cpu hotplug or kexec.

-Scott

