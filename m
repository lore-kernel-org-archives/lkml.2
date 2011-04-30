Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab1D3UeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:34:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40165 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1D3UeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R62KMK8i7oeMr+GADupehcK9mEHxL4rFZoNhIxDbaoRur4BgCoMov6E0BPPhh+T53Y
         Gd2paJPbn5/pdqaJ7tW0NB1qOYZp5q+XXZ/aSqSoPj12DswyfLDoAaV9I1ApwU369SKT
         h+ExYuZRYnFKYHGeIfYHCTTvFb3f4q5hlKB+Q=
Message-ID: <4DBC7231.5020806@gmail.com>
Date: Sun, 01 May 2011 00:33:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/2] x2apic optimization, round 4
References: <20110430171459.685415696@openvz.org> <4DBC6DC1.30900@redhat.com>
In-Reply-To: <4DBC6DC1.30900@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2011 12:14 AM, Avi Kivity wrote:
> On 04/30/2011 08:14 PM, Cyrill Gorcunov wrote:
>>    Hi Ingo, here is an updated series of two patches for
>> x2apic cluster mode ipi optimization. Please take a
>> look.
>>
>>    The only concern which was unresolved is a messy bit
>> in default_setup_apic_routing(), so we've added a FIXME
>> there and clean it up as only time permits. Actually I
>> have a plan to merge probe_32/64.c into single file (and
>> even started working on this task) but not yes succeed.
>>
>>    Anyway I think patches should be in a good shape now and
>> probably we could merge them to not lose?
>>
>>    Comments are welcome.
> 
> Very nice!  This will also significantly speed up kvm guests using x2apic.
> 

Yeah, indeed, i somehow forgot that we have x2apic mode in kvm (and just remember you've
been pointing me already about x2apic parameter for kvm ;)

-- 
Thanks,
  Cyrill
