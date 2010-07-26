Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0GZWXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:23:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41207 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab0GZWXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:23:10 -0400
Message-ID: <4C4E0A4D.3060305@zytor.com>
Date: Mon, 26 Jul 2010 15:21:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@intel.com>,
        Shaohua Li <shaohua.li@intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] x86, acpi: handle xapic/x2apic at same time
References: <4C4E047D.6030000@kernel.org>
In-Reply-To: <4C4E047D.6030000@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2010 02:56 PM, Yinghai Lu wrote:
> 
> one system have mixing xapic and x2apic entries in MADT and SRAT.
> 

Any way you could provide a name of this system, and/or an acpidump of it?

Thanks,

	-hpa
