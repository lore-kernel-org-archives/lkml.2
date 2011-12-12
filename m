Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1LLXmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:42:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43314 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1LLXma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:42:30 -0500
Message-ID: <4EE69158.5080805@zytor.com>
Date: Mon, 12 Dec 2011 15:42:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Berck E. Nash" <flyboy@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
References: <4EE2BC33.80902@gmail.com> <CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com> <20111211075713.GA20790@elte.hu> <CAE9FiQXk7y_oafNZG-QF5h3kDUQ3J6SP3A=ezHBT2W4Njo=uxQ@mail.gmail.com> <4EE5291C.1030302@gmail.com> <CAE9FiQXf2GzR2Uuw23CK7YVN4djtCd+aOFTRrf=96u9NTXRn=A@mail.gmail.com>
In-Reply-To: <CAE9FiQXf2GzR2Uuw23CK7YVN4djtCd+aOFTRrf=96u9NTXRn=A@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2011 07:40 PM, Yinghai Lu wrote:
> -v2: use x2apic_disabled instead of nox2apic, Suggested by Thomas
>      update x2apic_supported with x2apic_disabled, Suggested by Thomas

This is ugly.  Typically we have no- for boolean options.  If we have a
multivalue option it should be option=value, i.e. x2apic=disabled.  We
can allow x2apic_supported as a backwards compatibility option.

	-hpa

