Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0IALWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:22:23 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:39971 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753964Ab0IALWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:22:20 -0400
Message-ID: <4C7E3753.5080004@snapgear.com>
Date: Wed, 1 Sep 2010 21:21:55 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/22] Fix M68K irqflags
References: <4C7DF3B7.7010305@snapgear.com> <4C7B59E1.6010904@snapgear.com> <20100827015905.27277.39167.stgit@warthog.procyon.org.uk> <20100827020038.27277.27239.stgit@warthog.procyon.org.uk> <26799.1283201411@redhat.com> <2084.1283337793@redhat.com>
In-Reply-To: <2084.1283337793@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2010 11:22:07.0923 (UTC) FILETIME=[E9C0B030:01CB49C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/10 20:43, David Howells wrote:
> Greg Ungerer<gerg@snapgear.com>  wrote:
>
>> Here is a spin of the same patch, only with a single irqflags.h.
>> It is closely modeled on the mm version, merging (and cleaning)
>> the non-mmu bits as needed. There is a fair bit of common code
>> in here.
>
> Thanks!
>
> I can compile test, but I can't run test (no h/w).

I can compile and run test on a ColdFire platfom tomorrow,
so that will at least check the non-mmu m68k side of the
changes.

Regards
Greg


