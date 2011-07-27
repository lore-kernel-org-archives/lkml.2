Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab1G0AmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:42:08 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41942 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab1G0AmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:42:05 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MWOjjB0RiWLWS8yf0u0gRqOL3JP0StyrtP1kbA+i92SfA@mail.gmail.com>
References: <4E1D9C25.8080300@suse.cz>
	<1311634718-32588-1-git-send-email-mmarek@suse.cz>
	<CAM_iQpUEfYrrtpcRLTekSHMHrTTka6ir=z_GUUbnxuQKfY+OXA@mail.gmail.com>
	<4E2EBF63.8050208@suse.cz>
	<20110726080443.62196869.rdunlap@xenotime.net>
	<4E2F0735.1070403@suse.cz>
	<20110726112824.b357c756.rdunlap@xenotime.net>
	<CACqU3MWOjjB0RiWLWS8yf0u0gRqOL3JP0StyrtP1kbA+i92SfA@mail.gmail.com>
Date: Tue, 26 Jul 2011 20:42:04 -0400
Message-ID: <CACqU3MWopoJcd+5ELWEDp6_GvVpEjOHLnkcj4s_fHT5unp+MtA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] kconfig: Introduce KCONFIG(), KCONFIG_BUILTIN()
 and KCONFIG_MODULE()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kbuild@vger.kernel.org, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 26, 2011 at 2:48 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Tue, Jul 26, 2011 at 2:28 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On Tue, 26 Jul 2011 20:28:05 +0200 Michal Marek wrote:
>>
>>> Dne 26.7.2011 17:04, Randy Dunlap napsal(a):
>>> > On Tue, 26 Jul 2011 15:21:39 +0200 Michal Marek wrote:
>>> >> On 26.7.2011 15:01, Américo Wang wrote:
>>> >>> BTW, the name KCONFIG(CONFIG_NUMA) seems ugly.
>>> >>
>>> >> Suggest a better one :). The proposals so far:
>>> >> config_is_numa() (breaks grep)
>>> >
>>> > explain, please.
>>>
>>> If you grep for CONFIG_FOO usage, you'll miss this alternate syntax.
>>>
>>
>> Ack.
>>
>>>
>>> >> CONFIGURED(CONFIG_NUMA)
>>> >> ENABLED(CONFIG_NUMA)
>>> >> KCONFIG(CONFIG_NUMA)
>>> >
>>> > CONFIG(NUMA) || CONFIG(NUMA_BUILTIN) || CONFIG(NUMA_MODULE)
>>>
>>> same problem.
>>
>> Yes, I sorta got that after I sent the email.
>>
>> I guess I prefer your ENABLED() syntax then.
>>
> we need to be careful about namespace pollution/collision.
>
For the sake of having numbers:

% git grep -w ENABLED . | wc -l
    116
% git grep -w CONFIGURED . | wc -l
     11
% git grep -w KCONFIG . | wc -l
      1

>  - Arnaud
>
