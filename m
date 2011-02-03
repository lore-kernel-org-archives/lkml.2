Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1BCWNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:13:24 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:46640 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1BCWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:13:21 -0500
Message-ID: <4D4B2883.4020701@pardus.org.tr>
Date: Fri, 04 Feb 2011 00:13:23 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101312352.30883.rjw@sisk.pl> <4D4B19D3.2080800@pardus.org.tr> <201102032304.46724.rjw@sisk.pl>
In-Reply-To: <201102032304.46724.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.02.2011 00:04, Rafael J. Wysocki wrote:

>
> I guess we see a few different problems here.
>
> Can you remind me, please, what the known workarounds are?

OK in summary:

ASUS X71S - Doesn't boot without nolapic
ASUS F50SV - Doesn't boot without nolapic (latest tried and working 2.6.31)
ASUS N61JQ - X out of Y shutdown hangs (Cured with nolapic too)

Note that nolapic is the finer grained fix. acpi=off fixes the issue too.

Doesn't seem to be related to idle as processor.max_cstates=0 didn't help.

This is 2.6.37, intel_idle enabled with 2 upstream patches mentioned 
before + the mm fix.


-- 
Pardus Linux
http://www.pardus.org.tr/eng
