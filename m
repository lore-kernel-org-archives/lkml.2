Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1LMBZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:25:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47888 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab1LMBZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:25:28 -0500
MIME-Version: 1.0
In-Reply-To: <4EE69158.5080805@zytor.com>
References: <4EE2BC33.80902@gmail.com>
	<CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
	<20111211075713.GA20790@elte.hu>
	<CAE9FiQXk7y_oafNZG-QF5h3kDUQ3J6SP3A=ezHBT2W4Njo=uxQ@mail.gmail.com>
	<4EE5291C.1030302@gmail.com>
	<CAE9FiQXf2GzR2Uuw23CK7YVN4djtCd+aOFTRrf=96u9NTXRn=A@mail.gmail.com>
	<4EE69158.5080805@zytor.com>
Date: Mon, 12 Dec 2011 17:25:27 -0800
X-Google-Sender-Auth: 2YSkca632l2bMdwUIsh1wYhVefk
Message-ID: <CAE9FiQWUhp1v86YZ=rGL3g=5EfgAOt1OCGkH2b7ut0juOebeaw@mail.gmail.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Berck E. Nash" <flyboy@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 3:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/11/2011 07:40 PM, Yinghai Lu wrote:
>> -v2: use x2apic_disabled instead of nox2apic, Suggested by Thomas
>>      update x2apic_supported with x2apic_disabled, Suggested by Thomas
>
> This is ugly.  Typically we have no- for boolean options.  If we have a
> multivalue option it should be option=value, i.e. x2apic=disabled.  We
> can allow x2apic_supported as a backwards compatibility option.

x2apic_disabled is variable.

for command line, still use nox2apic for that purpose.

Thanks

Yinghai
