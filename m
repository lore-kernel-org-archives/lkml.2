Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab2AJT7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:59:46 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:39235 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932527Ab2AJT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:59:44 -0500
Message-ID: <4F0CA652.5040103@xenotime.net>
Date: Tue, 10 Jan 2012 12:57:54 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: Tree for Jan 9 (arch/x86/pci/amd_bus.c)
References: <20120109170457.4465dfc66a0eace4a2230fef@canb.auug.org.au> <4F0B569B.6050004@xenotime.net> <CAErSpo4+remnOA6gJXOz_54CsbbcOq_Yj=ua9gV_bq5dZ64ABA@mail.gmail.com>
In-Reply-To: <CAErSpo4+remnOA6gJXOz_54CsbbcOq_Yj=ua9gV_bq5dZ64ABA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 02:40 PM, Bjorn Helgaas wrote:
> On Mon, Jan 9, 2012 at 2:05 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> on several i386 builds:
>>
>> amd_bus.c:(.init.text+0x134b): undefined reference to `amd_get_mmconfig_range'
> 
> This is my fault.  I moved some code from amd_bus.c to amd_nb.c, and builds with
> 
>         CONFIG_PCI=y
>         # CONFIG_AMD_NB not set
> 
> now fail.  The attached patch should fix it.  I'll repost the series
> ("x86/PCI: amd: factor out MMCONFIG discovery") with the fix.
> 
> Yinghai, it looks to me like there's no reason to build amd_bus.o
> unless we have CONFIG_AMD_NB=y, but speak up if I'm wrong :)

Seems to work for me.  Thanks.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
