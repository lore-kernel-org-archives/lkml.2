Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab2JQQu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:50:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32901 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab2JQQuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:50:25 -0400
Message-ID: <507EE1C3.7070300@zytor.com>
Date: Wed, 17 Oct 2012 09:50:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI S3 and Xen
 (suprisingly small\!).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <507ED6C0.4020503@zytor.com> <20121017161036.GA10691@phenom.dumpdata.com>
In-Reply-To: <20121017161036.GA10691@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 09:10 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 17, 2012 at 09:03:12AM -0700, H. Peter Anvin wrote:
>> On 10/17/2012 06:49 AM, Konrad Rzeszutek Wilk wrote:
>>>
>>> Note: These are the other patches that went in 3.7-rc1:
>>> xen/bootup: allow {read|write}_cr8 pvops call [https://lkml.org/lkml/2012/10/10/339]
>>> xen/bootup: allow read_tscp call for Xen PV guests. [https://lkml.org/lkml/2012/10/10/340]
>>>
>>
>> So WTF do we have a read_tscp PV call?  Again, if there isn't a user
>> we should just axe it...
>
> Let me spin off a patch to see if that can be done.
>

Could you do an audit for other pvops calls that have no users?  If the 
*only* user is lguest, we should talk about it, too...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

