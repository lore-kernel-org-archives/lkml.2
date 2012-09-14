Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2INOGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:06:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43664 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab2INOGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:06:01 -0400
Message-ID: <505339C5.60907@arm.com>
Date: Fri, 14 Sep 2012 15:05:57 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH v4 02/24] xen/arm: hypercalls
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-2-git-send-email-stefano.stabellini@eu.citrix.com> <50533500.2020606@arm.com> <alpine.DEB.2.02.1209141458340.29232@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1209141458340.29232@kaball.uk.xensource.com>
X-Enigmail-Version: 1.5a1pre
X-OriginalArrivalTime: 14 Sep 2012 14:05:58.0826 (UTC) FILETIME=[10C370A0:01CD9282]
X-MC-Unique: 112091415060009001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/12 15:02, Stefano Stabellini wrote:
> On Fri, 14 Sep 2012, Marc Zyngier wrote:
>>> +/* HVC 0xEA1 */
>>> +#ifdef CONFIG_THUMB2_KERNEL
>>> +#define xen_hvc .word 0xf7e08ea1
>>> +#else
>>> +#define xen_hvc .word 0xe140ea71
>>> +#endif
>>
>> You should consider using Dave Martin's opcode injection series for
>> that. The patches are already in Russell's for-next branch.
> 
> I am all for using Dave's patches and I have even already sent a patch
> to change the wrappers to use __HVC:
> 
> http://marc.info/?l=linux-kernel&m=134513261623427&w=2
> 
> I have only temporarely dropped it, only to reduce the amount of
> external dependencies of this series. It already depends on Konrad's
> stable/for-linus-3.7, so I would rather send this patch out later on its
> own...

Fair enough. As long as there's a plan to fix this soon enough, it
should be alright.

	M.
-- 
Jazz is not dead. It just smells funny...

