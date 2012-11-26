Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab2KZUBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:01:16 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59167 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2KZUBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:01:14 -0500
Message-ID: <50B3CA73.5090205@linux.vnet.ibm.com>
Date: Mon, 26 Nov 2012 14:00:51 -0600
From: Michael Wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, glommer@parallels.com, mingo@redhat.com,
        avi@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH RFC V2 0/5] Separate consigned (expected steal) from steal
 time.
References: <20121017022249.16949.2775.stgit@lambeau> <50856760.2030507@redhat.com>
In-Reply-To: <50856760.2030507@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12112620-5816-0000-0000-0000058E51DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 10:33 AM, Rik van Riel wrote:
> On 10/16/2012 10:23 PM, Michael Wolf wrote:
>> In the case of where you have a system that is running in a
>> capped or overcommitted environment the user may see steal time
>> being reported in accounting tools such as top or vmstat.  This can
>> cause confusion for the end user.
>
> How do s390 and Power systems deal with reporting that kind
> of information?
>
> IMHO it would be good to see what those do, so we do not end
> up re-inventing the wheel, and confusing admins with yet another
> way of reporting the information...
>
Sorry for the delay in the response.  I'm assuming you are asking about 
s390 and Power lpars.
In the case of lpar on POWER systems they simply report steal time and 
do not alter it in any way.
They do however report how much processor is assigned to the partition 
and that information is
in /proc/ppc64/lparcfg.

Mike

