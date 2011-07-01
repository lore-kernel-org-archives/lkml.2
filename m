Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1GABSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:18:25 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:19538
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670Ab1GABSX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:18:23 -0400
X-SpamScore: -4
X-BigFish: VS-4(zz9371M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h1a1r61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Gala Kumar-B11780 <B11780@freescale.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "greg@kroah.com" <greg@kroah.com>, "akpm@kernel.org" <akpm@kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-console@vger.kernel.org" <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v6] drivers/virt: introduce Freescale hypervisor
 management driver
Thread-Topic: [PATCH 7/7] [v6] drivers/virt: introduce Freescale hypervisor
 management driver
Thread-Index: AQHMN4zAQUHEITu9+kSoiB4MK937mw==
Date: Fri, 1 Jul 2011 01:18:15 +0000
Message-ID: <BANLkTi=3r=UQYJVqRLRe-eu7rdkXQS-ESQ@mail.gmail.com>
References: <1307652726-4356-1-git-send-email-timur@freescale.com>
	<201106092304.55479.arnd@arndb.de>
In-Reply-To: <201106092304.55479.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.129.36.64]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <4EA51EC6BB80F340A5CB3FBBFBD06B1C@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 4:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 09 June 2011 22:52:06 Timur Tabi wrote:
>> Add the drivers/virt directory, which houses drivers that support
>> virtualization environments, and add the Freescale hypervisor management
>> driver.
....
>>
>> Signed-off-by: Timur Tabi <timur@freescale.com>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

So I've made the changes that people have asked for, and Arnd has
acked this driver.  Who's going to pick it up?  Who will be the
maintainer for drivers/virt?  I'd really like to see this driver in
3.1, and there's not much time left.

-- 
Timur Tabi
Linux kernel developer at Freescale
