Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0IYA0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 20:26:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44744 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab0IYA0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 20:26:50 -0400
Message-ID: <4C9D4177.5020101@zytor.com>
Date: Fri, 24 Sep 2010 17:25:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Prarit Bhargava <prarit@redhat.com>, fredlwm@gmail.com,
        Simon Arlott <simon@fire.lp0.eu>, x86@kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Marc Jones <marcj303@gmail.com>,
        Jordan Crouse <jcrouse@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, HPET: mark HPET PCI BARs as IORESOURCE_PCI_FIXED
References: <20100923233047.12463.61480.stgit@bob.kio>	<201009241706.11742.bjorn.helgaas@hp.com> <AANLkTi=GrH4fR_wSFytaSiXsH+wo2a=DaLAU4H2d0d1M@mail.gmail.com> <4C9D3D79.9060908@zytor.com> <4C9D3E8B.7090000@kernel.org>
In-Reply-To: <4C9D3E8B.7090000@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 05:12 PM, Yinghai Lu wrote:
>>
>> No, because the problem is known to happen on multiple vendors.
>>
> Do you have URL to them?
> 
> INTEL ?
> ServerWorks?
> Via?
> 

It'll happen on any platform where the HPET is a BAR.  There is no point
in enumerating it by vendor, since there is a static test for it.

	-hpa

