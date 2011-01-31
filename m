Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1AaUVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:21:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43346 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1AaUVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:21:22 -0500
MIME-Version: 1.0
In-Reply-To: <20110131113657.GC13541@zod.rchland.ibm.com>
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
 <20110131074502.9058.11473.stgit@localhost6.localdomain6> <20110131113657.GC13541@zod.rchland.ibm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 31 Jan 2011 13:20:48 -0700
X-Google-Sender-Auth: D5ZyICg3E_kS6kWgbvLpubpPzVQ
Message-ID: <AANLkTin5s3xLfhERvBCKN9+4ZoRVEGt7Zq_2XFWwn=TR@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt: Remove obsolete description of powerpc boot interface
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 4:36 AM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> On Mon, Jan 31, 2011 at 12:45:05AM -0700, Grant Likely wrote:
>>32 and 64 bit powerpc support has been merged for a while now, but
>>the booting-without-of.txt document still describes 32 bit as not
>>supporting multiplatform, which is no longer true.  This patch fixes
>>the documentation.
>>
>>Also remove references to powerpc-specific details outside of section
>>I in preparation to add details for other architectures.
>
> There's a line around 500 that starts:
>
>        "The kernel powerpc generic code does..."
>
> Perhaps the powerpc reference should be dropped there?

Done

>
> Also, there are several mentions of "real Open Firmware", which are
> probably just fine, and prom_init(), which are probably arch specific.

The prom_init() reference is just an example, and so I'm okay with it
staying in.  The example is relevant to look at regardless of the
architecture you are working on.  Oh, but I should drop the reference
to every node requiring a "device_type" property.

>
> There is a section that talks about ranges that starts with:
>
>        "For a new 64-bit powerpc board, I...".

Fixed.

>
> Section III 5) has all kinds of powerpc specific stuff.  CHRP,
> pSeries, PAPR in the root node.  The references to Apple machines for
> examples are probably OK, but it shouldn't make PowerPC items as
> explicit requirements.

Right, fixed.

>
> Section III 5e) references a file that doesn't exist:
> arch/ppc64/kernel/setup.c

Fixed

>
> Section V, paragraph 2 references a file that doesn't exist:
> arch/ppc64/kernel/prom.c


>
> Hope that helps you...
>
> josh
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
