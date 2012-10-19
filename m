Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab2JSHKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:10:54 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:9281 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756413Ab2JSHKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:10:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAKr7gFBXQing/2dsb2JhbAANOL0ghmQBAQEEMgFFARALGAkQAgQPCQMCAQIBRQYNAQcBAbFfk2uLWCeDAgeDEgOpEIE7Hw
Message-ID: <5080FCFA.8040003@belbone.be>
Date: Fri, 19 Oct 2012 09:10:50 +0200
From: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120918 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume
References: <507FF583.1070407@belbone.be> <50800F8C.10600@zytor.com>
In-Reply-To: <50800F8C.10600@zytor.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 04:17 PM, H. Peter Anvin wrote:
> On 10/18/2012 05:26 AM, Cédric Godin wrote:
>> Hello,
>>
>> After upgrading my kernel from 3.6 to 3.7-rc1 on my laptop, I can't resume anymore.
>> I bisected the problem to
>>
>
> There is a fix for this already queued up.  Please try the attached patch to verify that it fixes your problem.
>
>     -hpa
>
Hi Peter,

Indeed it fixes my problem.
Many thanks for the quick answer.

Cedric
