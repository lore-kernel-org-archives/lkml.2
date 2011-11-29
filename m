Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab1K2HRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:17:09 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:36669 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1K2HRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:17:06 -0500
Message-ID: <4ED486AF.5020707@linux.vnet.ibm.com>
Date: Tue, 29 Nov 2011 12:45:59 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
Newsgroups: gmane.linux.power-management.general,gmane.linux.ports.ppc64.devel,gmane.linux.kernel
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] cpuidle: (powerpc) Add cpu_idle_wait() to
 allow switching of idle routines
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>	<20111117112830.9191.1951.stgit@localhost6.localdomain6>	<1322434096.23348.6.camel@pasglop>	<4ED36A37.3030409@linux.vnet.ibm.com>	<1322512522.23348.43.camel@pasglop>	<4ED47EC2.2090802@linux.vnet.ibm.com> <1322550115.23348.72.camel@pasglop>
In-Reply-To: <1322550115.23348.72.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112907-3864-0000-0000-0000004ADB53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 12:31 PM, Benjamin Herrenschmidt wrote:

> On Tue, 2011-11-29 at 12:12 +0530, Deepthi Dharwar wrote:
>>
>> Yes, this could be problematic as there is small window for the
>> race condition to occur . Otherwise we need to manually schedule
>> it by running a kernel thread but this would definitely have a
>> overhead and would be an overkill. 
> 
> Depends what this "window" is. IE. What are you trying to protect
> yourself against ? What's the risk ?
> 
> If it's just module unload, then stop_machine is probably your
> friend :-)
> 
> Cheers,
> Ben.
> 
> 


Yup, it is the module unload that I am worried about. Otherwise
manually doing it using kernel thread would be an overkill -:(

Regards,
Deepthi

