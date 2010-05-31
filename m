Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0EaC7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 22:59:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62210 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab0EaC7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 22:59:22 -0400
Message-ID: <4C0325DE.6020604@oracle.com>
Date: Sun, 30 May 2010 19:58:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Documentation/timers/hpet_example.c compile bug
References: <20100528113514.GA3686@osiris.boeblingen.de.ibm.com>	<4C015FE6.8040004@oracle.com>	<4C03203B.3050501@oracle.com> <20100530194907.67399986@infradead.org>
In-Reply-To: <20100530194907.67399986@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090208.4C0325F2.004A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/10 19:49, Arjan van de Ven wrote:
> On Sun, 30 May 2010 19:34:35 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> Does it even make sense to build hpet_example on s390?
>> I.e., does s390 have hpet?
>> If not, then a simple Kconfig "depends on X86" or "depends on !S390"
>> will fix this.
> 
> HPET is very PC specific.
> 
> but.. even on x86, it does not really make sense, and exposing this as
> an interface to userspace is a historical mistake, the use of which we
> really ought to discourage.

Do you mean exposing anything that is in /usr/include/linux/hpet.h via ioctls?
especially struct hpet_info ?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
