Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0KKJoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:44:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab0KKJod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:44:33 -0500
Message-ID: <4CDBBAD4.1020301@redhat.com>
Date: Thu, 11 Nov 2010 11:43:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86, apic: Merge x2apic code
References: <20101110192053.GA6978@lenovo>
In-Reply-To: <20101110192053.GA6978@lenovo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 09:20 PM, Cyrill Gorcunov wrote:
>   Hi, while being at x2apic_x.c code I noted that files look similar to
> each other so I guessed may be we could merge them. As result --
> this patch.
>
>   Note that patch was only _compile_ tested, I don't have such apic for
> real. I've trying to make it carefully but more reviews are needed,
> I definitely might miss something.
>

Note kvm supports x2apic even if your host doesn't have one.  Boot with 
qemu -cpu host,+x2apic to enable the feature.

-- 
error compiling committee.c: too many arguments to function

