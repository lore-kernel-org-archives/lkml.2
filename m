Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422637Ab2JDPNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:13:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50297 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965590Ab2JDPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:13:51 -0400
MIME-Version: 1.0
In-Reply-To: <20121004141505.GJ9158@phenom.dumpdata.com>
References: <506C3B11.9010009@redhat.com>
	<1349286695-26713-1-git-send-email-yinghai@kernel.org>
	<1349286695-26713-5-git-send-email-yinghai@kernel.org>
	<20121004141505.GJ9158@phenom.dumpdata.com>
Date: Thu, 4 Oct 2012 08:13:50 -0700
X-Google-Sender-Auth: FHZJgvqi0x52kfBKFSZMpbfckt0
Message-ID: <CAE9FiQWK0jckdXx6S8LCLDSAfU8+318Qp1txe14McmvZN3v6MA@mail.gmail.com>
Subject: Re: [PATCH 4/5] PCI: Add max_vfs in sysfs per pci device where supports
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>, yuvalmin@broadcom.com,
        bhutchings@solarflare.com, gregory.v.rose@intel.com,
        davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 7:15 AM, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> On Wed, Oct 03, 2012 at 10:51:34AM -0700, Yinghai Lu wrote:
>> only pci device that support sriov will have max_vfs show up in /sys
>   ^-Only   ^-devices           ^-SRIOV
>
>>
>> when user set value in /sys, driver ops set_max_vfs will be called to enable
>> VF there.
>
> Huh? What value? What are they enabling? Your comment makes it sound as
> if setting any value (say '0xdeadbeef') will be called to enable a VF.
>
> I don't think that is what the code does. Can you explain what the
> proper values are to be submitted to the SysFS value 'max_vfs' and
> what the kernel ought to be doing? Perhaps include a little snippet
> from the kernel log so if somebody has a bug they can look at see
> what you got and can compare?

I sent out this patches  as reference or base for Don and greg.rose
and other sriov guys.

Anyway, thank you for review them.

Yinghai
