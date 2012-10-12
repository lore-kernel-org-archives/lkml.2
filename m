Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088Ab2JLSeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:34:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48479 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab2JLSeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:34:11 -0400
MIME-Version: 1.0
In-Reply-To: <5077F6E1.7090600@huawei.com>
References: <1350037890-5899-1-git-send-email-tangchen@cn.fujitsu.com>
	<1350037890-5899-3-git-send-email-tangchen@cn.fujitsu.com>
	<5077F2C2.1010300@huawei.com>
	<5077F407.3040205@cn.fujitsu.com>
	<5077F6E1.7090600@huawei.com>
Date: Fri, 12 Oct 2012 11:34:09 -0700
X-Google-Sender-Auth: mX1iKzpNPlFke9R7JMO_6BF_izo
Message-ID: <CAE9FiQUDy0Hb60z2E=UnYcF-06-Buoy+JFcNOvT8+3ic13Eokw@mail.gmail.com>
Subject: Re: [PATCH 2/3] Do not use acpi_device to find pci root bridge in
 _init code.
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, lenb@kernel.org, bhelgaas@google.com,
        izumi.taku@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 3:54 AM, Jiang Liu <jiang.liu@huawei.com> wrote:
> On 2012-10-12 18:42, Tang Chen wrote:
>> On 10/12/2012 06:36 PM, Jiang Liu wrote:
>>> I have sent a similar patch to Yinghai before. For simplicity, we could
>>> use acpi_match_object_info_ids() instead of acpi_match_device_ids()
>>> directly.
>>
>> Hum, I must have missed it. :)
>> Using acpi_match_object_info_ids() directly seems good. I'm just worry
>> about if it could cause any other problem. :)
>>
>> So now, is this bug fixed ? And we don't need these patches, right ?
>>
>> Thanks. :)
> I think Yinghai has missed my patch too, so just suggest to use
> acpi_match_object_info_ids() directly.

i put that patch from Jiang in my branch for while, and later found it
cause pci_root_bus notifying
do not work anymore, so i dropped that.

Yinghai
