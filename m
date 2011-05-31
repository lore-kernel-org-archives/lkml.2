Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab1EaJ0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:26:21 -0400
Received: from fnarfbargle.com ([93.93.131.224]:45979 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754781Ab1EaJ0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:26:20 -0400
Message-ID: <4DE4B432.1090203@fnarfbargle.com>
Date: Tue, 31 May 2011 17:26:10 +0800
From: Brad Campbell <lists2009@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
References: <4DE44333.9000903@fnarfbargle.com> <20110531054729.GA16852@liondog.tnic>
In-Reply-To: <20110531054729.GA16852@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/11 13:47, Borislav Petkov wrote:
> Looks like a KSM issue. Disabling CONFIG_KSM should at least stop your
> machine from oopsing.
>
> Adding linux-mm.
>

I initially thought that, so the second panic was produced with KSM 
disabled from boot.

echo 0 > /sys/kernel/mm/ksm/run

If you still think that compiling ksm out of the kernel will prevent it 
then I'm willing to give it a go.

It's a production server, so I can only really bounce it around after 
about 9PM - GMT+8.

Regards,
Brad
