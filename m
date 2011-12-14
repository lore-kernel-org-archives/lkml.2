Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab1LNXhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:37:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34823 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab1LNXg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:36:59 -0500
Message-ID: <4EE93302.9090900@zytor.com>
Date: Wed, 14 Dec 2011 15:36:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Mike Waychison <mikew@google.com>,
        Andi Kleen <andi@firstfloor.org>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86, efi: Break up large initrd reads
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>  <1318848017-12301-11-git-send-email-matt@console-pimps.org>  <4E9C8AAC.7080803@gmail.com>  <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECC4207.3010607@gmail.com>  <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECE5803.3060203@gmail.com>  <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECEF144.8020303@gmail.com> <1322210899.24448.66.camel@mfleming-mobl1.ger.corp.intel.com> <4EE689D5.4070600@zytor.com> <4EE798CF.7080903@linux.intel.com> <4EE93262.2030206@gmail.com>
In-Reply-To: <4EE93262.2030206@gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 03:33 PM, Maarten Lankhorst wrote:
> When I was testing in increments of 1 mb, 4 mb was the magic number that caused a hang.
> My system runs fine with 1mb and my original patch used that as blocksize.

Let's stick to 1 MiB.  Could you send an updated patch, including
changing the open-coding of the number into a #define?

Thanks,

	-hpa
