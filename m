Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab1CCB4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:56:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1CCB4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:56:09 -0500
Message-ID: <4D6EF536.305@redhat.com>
Date: Wed, 02 Mar 2011 20:56:06 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <4D665449.4050908@redhat.com> <20110224125702.GC29840@pcnci.linuxbox.cz> <20110225104823.GD29840@pcnci.linuxbox.cz> <4D67C077.6060108@redhat.com> <20110227172052.GB2474@nik-comp.lan> <4D6BA85B.7080908@redhat.com> <20110228143247.GE29840@pcnci.linuxbox.cz> <4D6BBC84.6020408@redhat.com> <20110228152823.GF29840@pcnci.linuxbox.cz> <4D6BC5CA.8060004@redhat.com> <20110228171550.GA2173@nik-comp.lan>
In-Reply-To: <20110228171550.GA2173@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> (resend, sorry for the mess)
>    

No worries.  What mess?

I have two things you can try:

first is running a single VCPU guest, if you have not done so already.

Second is adding the bootparameter "clocksource=acpi_pm" to your guest 
kernel.

If either of those fixes the problem, it very well have to do with this 
change and not that you may be missing later dependent patches.  This 
change should be nearly a 1-1 transformation, and if it is not, 
something is wrong.

What branch are you bisecting on, the kvm branch or the kernel tree 
itself?  It would be helpful to see the exact code in case any 
surrouding logic changed.

Thanks,

Zach
