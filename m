Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab1LWNPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:15:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35226 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017Ab1LWNPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:15:49 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>, Sergei Shtylyov <sshtylyov@mvista.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
Subject: RE: [PATCH v2] davinci: DA850 EVM: OHCI platform code
Thread-Topic: [PATCH v2] davinci: DA850 EVM: OHCI platform code
Thread-Index: AQHMv7In9gN6lV8zwEe0tpqykd2AsZXlsiWAgAAj7QCAAAVmgIABkwQAgAH6+cA=
Date: Fri, 23 Dec 2011 13:15:28 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC027573@DBDE01.ent.ti.com>
References: <1324452002-8388-1-git-send-email-prakash.pm@ti.com>
 <DF0F476B391FA8409C78302C7BA518B6051CB9@DBDE01.ent.ti.com>
 <4EF1CB8A.10309@mvista.com> <4EF1D011.8060103@mvista.com>
 <DF0F476B391FA8409C78302C7BA518B6053054@DBDE01.ent.ti.com>
In-Reply-To: <DF0F476B391FA8409C78302C7BA518B6053054@DBDE01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 17:57:16, Nori, Sekhar wrote:
[...]
> > 
> >     Well, I have one idea. We can create a separate module in 
> > arch/arm/mach-davinci/, named say ohci.c, put the shared code there and pass 
> > to it the GPIOs actually used via a function call. Or maybe use existing 
> > arch/arm/mach-davinci/usb.c.
> 
> Thanks Sergei. I think using the existing usb.c would be a better idea.
> 
> Prakash,
> 
> Can you please go ahead with this approach and post updated patches.
> 
> Thanks,
> Sekhar
> 

Ok I will create abstract function and post the new set of patches.

Thanks,
Prakash
