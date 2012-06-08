Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558Ab2FHIUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:20:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33557 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761946Ab2FHIU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:20:26 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8656:0:71a4:7cae:c1cb:99e8]
In-Reply-To: <CAK5ve-+3rKjeQA-WMQWvT48roFx-3Y-jNLZ3ciyOuH42x4Nu9A@mail.gmail.com>
References: <CAK5ve-JuZcjdbw_tV8vcriHWxOq1KFHm2mZBm6z3_j7hpPw-eA@mail.gmail.com>
	<CAK5ve-+3rKjeQA-WMQWvT48roFx-3Y-jNLZ3ciyOuH42x4Nu9A@mail.gmail.com>
Date: Fri, 8 Jun 2012 01:20:25 -0700
Message-ID: <CAOesGMgav2dqvUk623u_1ZuAE82drg2tF7rMpKMCZN4_Oq12_A@mail.gmail.com>
Subject: Re: [GIT PULL] LED CPU trigger driver and ARM LED code consolidation
From: Olof Johansson <olof@lixom.net>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 6, 2012 at 11:12 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> Hi Arnd and Olof,
>
> Is there any chance to pull this LED code into ARM SoC tree?
>
> Thanks,
> -Bryan
>
> On Mon, Jun 4, 2012 at 3:25 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
>> Hi Arnd and Olof,
>>
>> Please consider to pull my branch for LED CPU trigger driver and ARM
>> LED code consolidation, which is based on 3.5-rc1:
>>
>> The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:
>>
>>  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)
>>
>> are available in the git repository at:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
>> for-arm-soc

Pulled into arm-soc as devel/led-driver in next/drivers.


Thanks,

-Olof
