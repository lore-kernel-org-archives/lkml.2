Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2EIIFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:05:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41425 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab2EIIDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:03:46 -0400
X-AuditID: cbfee61a-b7b97ae000004342-2e-4faa24e11824
Message-id: <4FAA24E1.7040201@samsung.com>
Date: Wed, 09 May 2012 17:03:45 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] PM / Hibernate : Add wait for disk detection if
 resume_file is MAJOR:MINOR style
References: <4FA78724.5000401@samsung.com> <4FAA0ABB.8090906@linux.vnet.ibm.com>
In-reply-to: <4FAA0ABB.8090906@linux.vnet.ibm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 03:12 PM, Srivatsa S. Bhat wrote:
> On 05/07/2012 01:56 PM, Minho Ban wrote:
>> +	/* name_to_dev_t is ineffective if resume_file comes in major:minor
>> +	 * format */
> 
> 
> Nitpick: Multi-line comments should be of the form:
> 
> /*
>  * name_to_dev_t is ineffective....
>  * ....... major:minor format
>  */
> 

Thank you for pointing this out. I'll fix it.

Regards,
Minho Ban
