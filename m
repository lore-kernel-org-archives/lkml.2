Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab1CZBnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:43:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35630 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab1CZBnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:43:15 -0400
Message-ID: <4D8D44A7.6060605@oracle.com>
Date: Fri, 25 Mar 2011 18:43:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: fix nv_tco section mismatch
References: <20110324133244.acffd99a.randy.dunlap@oracle.com> <AANLkTikLSVpw73r_g++_oRs=nTjYf5WmH=XNjjp8o5uo@mail.gmail.com>
In-Reply-To: <AANLkTikLSVpw73r_g++_oRs=nTjYf5WmH=XNjjp8o5uo@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D8D44AA.0066,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/11 16:42, Mike Waychison wrote:
> On Thu, Mar 24, 2011 at 1:32 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix section mismatch warning:
>> Mark the called nv_tco_getdevice() as __devinit, just like its caller.
> 
> This looks fine.
> 
> I can't seem to reproduce the warning on my end however, compiling
> this as a built-in nor as a module.  How do I trigger a difference
> between __init and __devinit?

I just used allmodconfig.  But why wouldn't you see a differnence between
__init and __devinit?  They are defined differently in include/linux/init.h,
but maybe on some $arch, those sections are treated differently?

I dunno.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
