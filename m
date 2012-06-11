Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2FKO6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:58:02 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59891 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab2FKO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:58:00 -0400
Message-ID: <4FD6075F.5010307@linux.vnet.ibm.com>
Date: Mon, 11 Jun 2012 07:57:35 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Tomas M." <tmezzadra@gmail.com>,
        Ferenc Wagner <wferi@niif.hu>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Jean Pihet <j-pihet@ti.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        linux-pm@lists.linux-foundation.org, preeti@linux.vnet.ibm.com
Subject: Re: Suspend/resume regressions on Lenovo S10-3
References: <4FC2DA8C.7050401@linux.vnet.ibm.com> <4FCF5249.2070600@linux.vnet.ibm.com> <4FD5F329.2090302@linux.vnet.ibm.com>
In-Reply-To: <4FD5F329.2090302@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061114-7408-0000-0000-000005C08614
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 06:31 AM, Srivatsa S. Bhat wrote:
> Hi Dave,
> 
> On 06/06/2012 06:21 PM, Deepthi Dharwar wrote:
> 
>> On 05/28/2012 07:23 AM, Dave Hansen wrote:
>>
>>> I have a Lenovo S10-3 Atom netbook.  It's always had some amount of
>>> trouble working with the intel_idle driver, so I usually compile that
>>> out an use the acpi one.
> 
> 
> What problem did you face with intel_idle driver? Is it suspend/resume
> related?

With intel_idle, sometimes it won't boot, others it won't suspend/resume:

  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/674075

I'm actually not sure how it behaves on current kernels.

