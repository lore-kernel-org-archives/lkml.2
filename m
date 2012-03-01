Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2CATDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:03:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55689 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab2CATDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:03:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yhlu.kernel@gmail.com designates 10.236.116.66 as permitted sender) smtp.mail=yhlu.kernel@gmail.com; dkim=pass header.i=yhlu.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAL-B5D0Phxhx-2ipYwoKfZCTvCfuh6bX-iqQkQS0cLmRqQHGbg@mail.gmail.com>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
	<CAL-B5D0Phxhx-2ipYwoKfZCTvCfuh6bX-iqQkQS0cLmRqQHGbg@mail.gmail.com>
Date: Thu, 1 Mar 2012 11:03:15 -0800
X-Google-Sender-Auth: gUeUg-XEyxNnbvqcqOT93JVKiqs
Message-ID: <CAE9FiQX57=cmfgJJv5E_rTQD1umCsmqJas0Sa22sN_xhdCSUgw@mail.gmail.com>
Subject: Re: [PATCH 00/39] PCI: pci_host_bridge related cleanup and busn_alloc
From: Yinghai Lu <yinghai@kernel.org>
To: Myron Stowe <myron.stowe@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 10:51 AM, Myron Stowe <myron.stowe@gmail.com> wrote:
> On Wed, Feb 29, 2012 at 4:06 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> The first 14 patches are hostbridge clean up.
>> will add struct device dev into host_bridge struct.
>> also will add release support to make sure allocated resource get
>> freed during root bus removal including hostbridge and pci_sysdata.
>>
>> others 25 patches are busn_alloc related.
>> Set up iobusn_resource tree, and register bus number range to it.
>> Later when need to find bus range, will try to allocate from the tree
>> Need to test on arches other than x86. esp for ia64 and powerpc that support
>>  more than on peer root buses.
>
> Why did you collapse these two series into one at this point?
>
> Last I was keeping up with - there was a -v9 00/23 series related to
> bus_num and a -v2 00/11 series for pci_host_bridge related cleanup.

the updated busn_alloc patchset, need to be applied on top of
pci_host_bridge related cleanup.

So i was thinking put them together would be better to be reviewed
first 14 for hostbridge clean up. and others for busn_res_alloc.

>
> As a distro maintainer I need to try and keep up with what is occurring
> here and actions like this - coalescing multiple series - unnecessarily
> complicates things.  It also masks the fact that the bus_num series is
> now on -v10 within a very short time frame (which implies a lot).

I will separate them in next revision, if Jesse would not pick up
first 14 shortly.

Thanks

Yinghai
