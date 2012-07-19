Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2GSTMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:12:17 -0400
Received: from toro.web-alm.net ([62.245.132.31]:58168 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab2GSTMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:12:14 -0400
Message-Id: <20120719185212.184458166@osadl.org>
User-Agent: quilt/0.51-1
Date: Thu, 19 Jul 2012 20:52:12 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Rafael Wysocki <rjw@sisk.pl>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 0/1 v2] cpuidle: allow to disable C states of the ladder governor
References: <201207192042.57935.rjw@sisk.pl> <20120717185914.063547728@osadl.org> <5007EC10.1060508@linux.vnet.ibm.com> <5007F1F3.9090706@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

>>>>>> [..]
>>>>>> I could implement a sanitize mechanism of the ladder governor that
>>>>>> takes care the "disable" variables of all deeper states are set to 1,
>>>>>> if a state is disabled, and those of all lighter states are set to 0,
>>>>>> if a state is enabled. Do you wish me to do that?
>>>>> No, I dont think thats necessary, current code suffices it.
>>>>> The disable flag is knob we are giving to the user . So may be just
>>>>> document  the  intended use of disable flag working
>>>>> alongside design of ladder governor.
>>>> It's not necessary - but maybe better. Here comes v3 with a sanitizer.
>>>> Is this too ugly?
>>> The v2, with the documentation in place seems sufficient.
>>> Yup, this adds unnecessary fields which are not much use
>>> coz the same can be achieved with just disable flag check.
>> ok, let's take v2.
> Can you please resend the version regarded as the current one?

This is the version that was regarded as the current one (v2).

Changes in v2: A note in the documentation explains why the sysfs
variable "disable" may not always reflect the current situation
and why modifying it may not always work as expected.

	-Carsten.

