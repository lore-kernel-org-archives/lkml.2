Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1HKGPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 02:15:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab1HKGPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 02:15:36 -0400
Message-ID: <4E4372DD.6020603@redhat.com>
Date: Thu, 11 Aug 2011 08:12:45 +0200
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia@diku.dk>
Subject: Re: Missing put_cpu() in arch/ia64/sn/kernel/sn2/sn_hwperf.c?
References: <1312826703.5589.155.camel@localhost.localdomain> <CA+8MBbJDLrNHD0kGdYNv1WPnRh8G1aEY-T3xcS_wMpciTVcy7A@mail.gmail.com>
In-Reply-To: <CA+8MBbJDLrNHD0kGdYNv1WPnRh8G1aEY-T3xcS_wMpciTVcy7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/11 23:37, Tony Luck wrote:
> On Mon, Aug 8, 2011 at 11:05 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
>> The function sn_hwperf_op_cpu() seems to miss a corresponding put_cpu().
>>
>> Or is this done in another function? I didn't find it.
> 
> It would be hard to do it elsewhere - this function may not have done
> a get_cpu() [in the cpu == SN_HWPERF_ARG_ANY_CPU case].
> 
> The logic is a bit tortuous here ... perhaps simpler to split the tests
> up.  Does the attached patch look right?

Hi Tony,

You probably want someone from SGI to look at it, so I'll forward to
Robin Holt.

I haven't been at SGI for about 2 years now :)

Cheers,
Jes
