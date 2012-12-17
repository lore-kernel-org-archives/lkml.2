Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2LQJ1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:27:44 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:36897 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2LQJ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:27:43 -0500
Message-ID: <50CEE586.10800@itwm.fraunhofer.de>
Date: Mon, 17 Dec 2012 10:27:34 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [regression] 3.7 ends in APIC panic
References: <50CB3EAB.309@itwm.fraunhofer.de> <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com> <CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com> <50CE0C82.20708@itwm.fraunhofer.de> <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com>
In-Reply-To: <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: ISO-8859-1
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2012 07:07 PM, Yinghai Lu wrote:
> On Sun, Dec 16, 2012 at 10:01 AM, Bernd Schubert
> <bernd.schubert@itwm.fraunhofer.de> wrote:
>>> can you post your .config for v3.7 ?
>>>
>>> wonder if you have x2apic in .config
>>
>> Which setting is it? Config is attached.
>
> your config does not have
>
> CONFIG_X86_X2APIC=y
>
> set.
>
> please enable that.
>
> your BIOS pre-enable x2apic somehow, so you must have x2apic enabled in kernel.
>
> it x2apic really can not be re-enabled by kernel, kernel would disable
> x2apic automatically.

The system boots fine with x2apic enabled.


Thanks a bunch for your help,
Bernd

