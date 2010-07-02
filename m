Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab0GBVxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 17:53:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47710 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0GBVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 17:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <20100701151624.2bf6c533@wker>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com> 
	<AANLkTimvYT9MFPzX7xmCXPZ6ScFQZxO3zSKlcqczd_GO@mail.gmail.com> 
	<20100701151624.2bf6c533@wker>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 2 Jul 2010 15:53:17 -0600
X-Google-Sender-Auth: 5ZHANukt4JLyTPeDG59JT4wHYCE
Message-ID: <AANLkTil7SmMKi7LN4bdLvX75iFcNeYqskodpmn7s4Xu9@mail.gmail.com>
Subject: Re: [git pull] (updated) OF-related build breakage fixes
To: Anatolij Gustschin <agust@denx.de>
Cc: Dan Williams <dan.j.williams@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 7:16 AM, Anatolij Gustschin <agust@denx.de> wrote:
> On Thu, 1 Jul 2010 02:06:35 -0700
> Dan Williams <dan.j.williams@gmail.com> wrote:
>
>> of/dma: fix remaining ppc4xx build breakage
>>
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Commit 05c02542 "of/dma: fix build breakage in ppc4xx adma driver"
>> missed one conversion site.

Thanks Dan.  I've picked this up and will push it out to Linus

g.
