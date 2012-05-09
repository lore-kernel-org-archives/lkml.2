Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2EIPjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:39:25 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:54699 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759997Ab2EIPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:39:21 -0400
Message-ID: <1336577956.8274.364.camel@deadeye>
Subject: Re: [PATCH] pch_gbe: Adding read memory barriers
From: Ben Hutchings <bhutchings@solarflare.com>
To: Erwan Velu <erwanaliasr1@gmail.com>
CC: David Laight <David.Laight@aculab.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tshimizu818@gmail.com>
Date: Wed, 9 May 2012 16:39:16 +0100
In-Reply-To: <CAL2JzuxawnesC+=Fqyu71Hkwi5gnRughe_NYM4k1c=zqDoNGRg@mail.gmail.com>
References: <4FA822C4.60809@gmail.com>
	 <AE90C24D6B3A694183C094C60CF0A2F602CD83CB@saturn3.aculab.com>
	 <1336569510.8274.360.camel@deadeye>
	 <CAL2JzuxirjAnmbcV+R=MJFAi1+ayrRnM6i0Dz5poqMuG7Cxwxg@mail.gmail.com>
	 <AE90C24D6B3A694183C094C60CF0A2F602CD848A@saturn3.aculab.com>
	 <CAL2JzuxawnesC+=Fqyu71Hkwi5gnRughe_NYM4k1c=zqDoNGRg@mail.gmail.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18894.005
X-TM-AS-Result: No--17.422000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 17:20 +0200, Erwan Velu wrote:
> Thanks for this very clear description.

It might be clear, but it's not very relevant: you need to understand
the Linux kernel barrier APIs (which cover all architectures).  See
Documentation/memory-barriers.txt.

> As I'm pretty new to this kind of integration in the kernel, do you
> request me to test this volatile option ?
> Does the patch tends to be rejected for this issue ?
> What should be the next step for my patch ?
[...]

Explain what kind of reordering you are trying to avoid.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

