Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0KKRyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:54:44 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47666 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab0KKRyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:54:43 -0500
Message-ID: <4CDC2DDD.50508@linux.vnet.ibm.com>
Date: Thu, 11 Nov 2010 09:54:37 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw events
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org> <1289492117-18066-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1289492117-18066-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 08:15 AM, Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>
>
> Add support to the perf tool to specify extra values for raw events
> and pass them to the kernel.
>
> The new format is -e rXXXX[,YYYY]

It's not clear to me that a comma is the best character to use in this 
instance, because multiple events can be listed after the -e separated 
by commas as well, for example:  -e rXXXX,cycles.
-e rXXXX,YYYY,cycles would be confusing to read.

How about -e rXXXX[+YYYY]

- Corey
