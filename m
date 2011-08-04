Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab1HDJro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:47:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:19122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab1HDJrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:47:39 -0400
Message-ID: <4E3A6AEF.9000500@intel.com>
Date: Thu, 04 Aug 2011 12:48:31 +0300
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Organization: Intel Finland Oy, Helsinki, Finland
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] xen: asm/io.h should not include xen.h if XEN is
 disabled
References: <049cae3c2e2923ea7efbd205257e9e22b3df5e1a.1312388919.git.dmitry.kasatkin@intel.com> <CA+55aFzdMiyXiPrBfwW6Ra0P6qtJXf4MYRLB7NvkQdkerSzrUA@mail.gmail.com>
In-Reply-To: <CA+55aFzdMiyXiPrBfwW6Ra0P6qtJXf4MYRLB7NvkQdkerSzrUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/08/11 04:04, Linus Torvalds wrote:
> On Wed, Aug 3, 2011 at 6:33 AM, Dmitry Kasatkin
> <dmitry.kasatkin@intel.com> wrote:
>> XEN related content is behind the CONFIG_XEN flag in the io.h.
>> And <xen/xen.h> should be also behind CONFIG_XEN flag.
> Wouldn't it be much nicer to just move the '#include <xen/xen.h>' line down?
>
It is probably a mater of taste.. to keep includes on the top.
> Does the attached patch work for you?
>
Yes, it works...
I experienced a problem in building some modules because of that include.
In older kernel version (before .38 or so) everything was fine - it was
not <xen/xen.h> includes in io.h

>               Linus

Thank you..

