Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab2GSLmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:42:19 -0400
Received: from toro.web-alm.net ([62.245.132.31]:57032 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab2GSLmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:42:16 -0400
Message-ID: <5007F1F3.9090706@osadl.org>
Date: Thu, 19 Jul 2012 13:39:31 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/1 v3] Honor state disabling in the cpuidle ladder governor
 - with sanitizer
References: <20120717185914.063547728@osadl.org> <20120717190330.700421963@osadl.org> <50065953.9040904@linux.vnet.ibm.com> <500697A9.6070101@osadl.org> <5006A2A6.8030902@linux.vnet.ibm.com> <5006CA64.4070003@osadl.org> <5007EC10.1060508@linux.vnet.ibm.com>
In-Reply-To: <5007EC10.1060508@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deepthi,

>>> [..]
>>>> I could implement a sanitize mechanism of the ladder governor that
>>>> takes care the "disable" variables of all deeper states are set to 1,
>>>> if a state is disabled, and those of all lighter states are set to 0,
>>>> if a state is enabled. Do you wish me to do that?
>>> No, I dont think thats necessary, current code suffices it.
>>> The disable flag is knob we are giving to the user . So may be just
>>> document  the  intended use of disable flag working
>>> alongside design of ladder governor.
>> It's not necessary - but maybe better. Here comes v3 with a sanitizer.
>> Is this too ugly?
> The v2, with the documentation in place seems sufficient.
> Yup, this adds unnecessary fields which are not much use
> coz the same can be achieved with just disable flag check.
ok, let's take v2.

> Also, any reason why the patch is being sent as an attachment ?
> Sending patches as an attachment is not a recommended practice.
Sorry.

	-Carsten.
