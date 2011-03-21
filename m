Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1CUGoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 02:44:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab1CUGn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 02:43:59 -0400
Message-ID: <4D86F3A7.8060706@redhat.com>
Date: Mon, 21 Mar 2011 14:43:51 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org, Takao Indoh <tindoh@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Len Brown <lenb@kernel.org>,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
References: <1299766243-494-1-git-send-email-amwang@redhat.com> <20110310082600.b52de7fb.rdunlap@xenotime.net>
In-Reply-To: <20110310082600.b52de7fb.rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月11日 00:26, Randy Dunlap 写道:
> On Thu, 10 Mar 2011 22:10:43 +0800 Amerigo Wang wrote:
>> +	acpi_addr=	[ACPI,EFI]
>> +			Pass the RSDP address to the kernel, mostly used
>> +			on machines running EFI runtime service to boot the
>> +			second kernel for kdump.
>> +
>
> I think that "acpi_addr" is a bit too generic.  How about
> acpi_rsdp or acpi_root instead?
>

Yup, I agree "acpi_rsdp" is better.

Thanks.
