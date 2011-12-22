Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1LVHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:25:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56271 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab1LVHZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:25:53 -0500
MIME-Version: 1.0
In-Reply-To: <1324518840.21294.14.camel@sbsiddha-desk.sc.intel.com>
References: <1324083546-1003-1-git-send-email-yinghai@kernel.org>
	<1324363882.2286.23.camel@sbsiddha-mobl2>
	<CAE9FiQU__U0CCiyzF9kDC1Z=PUEoTe1Jm-M97EbCO440Vm9P_A@mail.gmail.com>
	<CAE9FiQXodjK=GRO2ut4fGS=wXBc59+rov-BVKXhDGK8vJVBHhQ@mail.gmail.com>
	<1324518840.21294.14.camel@sbsiddha-desk.sc.intel.com>
Date: Wed, 21 Dec 2011 23:25:53 -0800
X-Google-Sender-Auth: WSZgUuhZtl8iwy9jCFfFSWKzhlU
Message-ID: <CAE9FiQWqs4uwPz6bUw6WB56Z-kjC-gnN7t-LYbKWxpcgkHLfFA@mail.gmail.com>
Subject: Re: [PATCH -v8] x86: Disable x2apic if nox2apic is specified or
 intr-remap can not be enabled
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 5:54 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Tue, 2011-12-20 at 18:24 -0800, Yinghai Lu wrote:
>> put your updated version as v9.
>>
>> like to let ingo or hpa or thomas to decide v8 or v9 to be used.
>>
>>         Changes:
>>                  1. clear x2apic cpu features
>>                  2. disable x2apic later instead of check_x2apic()
>
> Yinghai, It is not the question of just cleanup. changing the apic mode
> has to follow some sequence.
>
> Anyways, I have done all the changes and other minor cleanups. Also
> split up your patch into multiple patches and posted it now.
>
> Please let me know if you see any issue.

updated 4/5 for some minor problem with applying and compiling.

Please check that.

Thanks

Yinghai
