Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0DSWzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:55:10 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:42682 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab0DSWzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w37mcH0eEw7K1xqKLw+kVhlJAh6f0CKmRy+mGLlSU37RrWSR9R9zt/dvILtrRhuJDx
         LbgcbqDecWJKssCBFqNM2zN6kgYJdz4kFr7LJ6oeKfFfsFrxyEQcABFH26DXt6ZwtQks
         beQnec9kmwvzGg24Wk0Wa+tENmQgmNkmRGO94=
Message-ID: <4BCCDFA0.10501@gmail.com>
Date: Mon, 19 Apr 2010 15:56:32 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Backlund <tmb@mandriva.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: MacBookPro2,2 unable too boot with the latest HEAD
References: <i2vdd18b0c31004140812i6a0e9430u68ab49b24273fe9b@mail.gmail.com>	<20100419142804.3cd53666.akpm@linux-foundation.org>	<4BCCCCDF.4010605@gmail.com> <20100419145741.95688467.akpm@linux-foundation.org> <4BCCD2DC.7040301@mandriva.org>
In-Reply-To: <4BCCD2DC.7040301@mandriva.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 03:02 PM, Thomas Backlund wrote:
> On 20.4.2010 00:57, Andrew Morton wrote:
>> On Mon, 19 Apr 2010 14:36:31 -0700
>> "Justin P. Mattock"<justinmattock@gmail.com> wrote:
>>
>>> On 04/19/2010 02:28 PM, Andrew Morton wrote:
>>>> On Wed, 14 Apr 2010 08:12:57 -0700
>>>> Justin Mattock<justinmattock@gmail.com> wrote:
>>>>
>>>>> Just noticed this this morning,
>>>>> system can only boot up when I take the battery
>>>>> out.(when the battery is plugged in this(below)
>>>>> shows up, and if booting no go)
>>>>>
>>>>> [ 169.207193] divide error: 0000 [#1] SMP
>>>>> [ 169.207203] last sysfs file:
>>>>> /sys/devices/platform/applesmc.768/light
>>>>> [ 169.207208] CPU 0
>>>>> [ 169.207212] Modules linked in: rfcomm sco radeon bnep l2cap ttm
>>>>> drm_kms_helper drm ipt_LOG iptable_nat nf_nat xt_state
>>>>> nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
>>>>> iptable_filter ip_tables x_tables btusb bluetooth firewire_ohci ath9k
>>>>> firewire_core ath9k_common video battery ac ath9k_hw evdev joydev
>>>>> ohci1394 ath button thermal sky2 i2c_i801 raw1394 ieee1394 uhci_hcd
>>>>> ehci_hcd coretemp acpi_cpufreq processor appletouch applesmc uvcvideo
>>>>> [ 169.207303]
>>>>> [ 169.207310] Pid: 182, comm: kacpi_notify Not tainted
>>>>> 2.6.34-rc3-00502-gd3b0936 #42 Mac-F42187C8/MacBookPro2,2
>>>>> [ 169.207316] RIP: 0010:[<ffffffff81237e43>] [<ffffffff81237e43>]
>>>>> acpi_ex_extract_from_field+0xb1/0x24a
>>>>
>>>> Presumably acpi_ex_extract_from_field() fed zero into (the misnamed)
>>>> ACPI_ROUND_UP_TO().
>>>>
>>>> I'll ask Rafael and Maciej to track this as a post-26.33 regression,
>>>> thanks.
>>>>
>>>>
>>>
>>> the patch here fixes it for me:ACPI: EC: Limit burst to 64 bit
>>> https://bugzilla.kernel.org/attachment.cgi?id=25962
>>
>> hm. I wonder how you go from a bugzilla attachment back up tot he bug
>> to which it is attached?
>>
>> Oh well. Alexey, I trust that patch is in the 2.6.34 queue?
>>
>
> It's already in Linus tree, commit 2060c44576c79086ff24718878d7edaa7384a985
>
> --
> Thomas
>


cool thanks.. just pulled,
rebooted everything looks good.

cheers,

Justin P. Mattock
