Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1EJUpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:45:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38119 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1EJUpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:45:09 -0400
Message-ID: <4DC9A3A2.20000@zytor.com>
Date: Tue, 10 May 2011 13:44:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: Borislav Petkov <bp@amd64.org>, Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "mikew@google.com" <mikew@google.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] pstore: EFI Support
References: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4712@USINDEVS01.corp.hds.com> <20110510161137.GA14522@kroah.com> <20110510165728.GC3347@gere.osrc.amd.com> <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4815@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4815@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 12:18 PM, Seiji Aguchi wrote:
> Hi,
>
> Thank you for your comments.
>
>> Btw, is this case of the possibility for APEI of corrupting NVRAM
>> storage something you actually experienced on a real machine or simply a
>> conclusion from looking at APEI code doing ioremap()?
>
> I simply concluded from looking at ioremap() of APEI code.
>

The thing is that you're effectively betting that the EFI method will be 
less broken than our kernels.  That is not at all given...

	-hpa
