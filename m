Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0FQGXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:23:25 -0400
Received: from smtp.nokia.com ([192.100.122.233]:22331 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab0FQGXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:23:23 -0400
From: <Igor.Stoppa@nokia.com>
To: <lenb@kernel.org>, <linux-pm@lists.osdl.org>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>
Date: Thu, 17 Jun 2010 08:03:50 +0200
Subject: RE: [linux-pm] RFC: /sys/power/policy_preference
Thread-Topic: [linux-pm] RFC: /sys/power/policy_preference
Thread-Index: AcsNmF3GpDEcA3XkRDaTRBqcEVPSmQASPeLp
Message-ID: <D32AB456855CBD4987499F68AFA421F4299A56E336@NOK-EUMSG-02.mgdnok.nokia.com>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 17 Jun 2010 06:03:51.0057 (UTC) FILETIME=[DBBD3010:01CB0DE2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> From:  Len Brown [lenb@kernel.org]

policy_preference has 5 levels, from max_performance
through max_powersave.  Here is how 4 parts of the kernel
might respond to those 5 levels:

[levels description]

i do understand that you are mostly targetting acpi based systems, but even there, based on static leaks, it might not be always true that lower frequencies are correlated to higher power savings (or maybe i have misunderstood your draft - i am not so fluent in acpi)

> it is likely
> that some users would want to use "powersave" when on
> battery and perhaps shift to "performance" on A/C.

if we consider also the thermal envelope and the fact that "performance" might steal power from a charging battery, even ton A/C it might not be possible to settle down in one state permanently.

Or do you expect other mechanisms to intervene?

Cheers, igor