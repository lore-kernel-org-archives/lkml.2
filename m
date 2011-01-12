Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab1ALW5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:57:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45334 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1ALW5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:57:15 -0500
Message-ID: <4D2E313D.3040209@oracle.com>
Date: Wed, 12 Jan 2011 14:54:53 -0800
From: Randy Dunlap <randy.dunlap@Oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>
Subject: Re: on builds/randconfigs
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au> <alpine.LFD.2.02.1101121257580.18873@x980> <20110112131800.d64c1a86.akpm@linux-foundation.org> <201101122224.54330.rjw@sisk.pl> <alpine.LFD.2.02.1101121654000.19754@x980>
In-Reply-To: <alpine.LFD.2.02.1101121654000.19754@x980>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/11 13:58, Len Brown wrote:
>>> These unusable config combinations should be prevented via Kconfig. 
>>> That prevents users from selecting them, which otherwise adds to
>>> our workload and to theirs.  It also prevents false-positives
>>> during our useful randconfig testing.
>>
>> But it is kind of difficult to achieve IMhO.  For example, there are options
>> that are only SELECTed if something else is set, but randconfig doesn't seem
>> to care.

s/randconfig/kconfig/


> Kconfig select needs to be fixed so that it is not possible to
> select something if that something's dependencies are not met.
> 
> This long standing issue is independent of randconfig,
> but Randy can probably attest that a measurable portion
> of the randconfig failures are due to this bug.

Certainly.  At least now we have a kconfig warning on this class of
problem.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
