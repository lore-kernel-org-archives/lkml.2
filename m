Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2HTBJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 21:09:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56993 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2HTBJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 21:09:18 -0400
MIME-Version: 1.0
In-Reply-To: <87393jmanq.fsf@nemi.mork.no>
References: <1343975435-25469-1-git-send-email-ying.huang@intel.com>
	<87393jmanq.fsf@nemi.mork.no>
Date: Mon, 20 Aug 2012 09:09:16 +0800
Message-ID: <CAC=cRTPQTtn4y8pNh2hN6tRk7OPJQ7mjcsiGkcK0pR0TE=KWkA@mail.gmail.com>
Subject: Re: [PATCH 0/4] PCI/PM: PCI D3cold support fixes for 3.6-rc1
From: huang ying <huang.ying.caritas@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn,

Could you please merge this patchset?  They fix real bugs.

Best Regards,
Huang Ying

On Sun, Aug 19, 2012 at 6:35 PM, Bjørn Mork <bjorn@mork.no> wrote:
> Huang Ying <ying.huang@intel.com> writes:
>
>> [BUGFIX 1/4] PCI/PM: enable D3/D3cold by default for most devices
>> [BUGFIX 2/4] PCI/PM: Keep parent bridge active when probing device
>> [BUGFIX 3/4] PCI/PM: Fix config reg access for D3cold and bridge suspending
>> [PATCH 4/4] PCI/PM: Add ABI document for sysfs file d3cold_allowed
>
> Hello,
>
> I am hoping these patches will appear in 3.6?  They fix real problems in
> 3.6-rc1 for me. If it helps in any way, feel free to add
>
> Tested-by: Bjørn Mork <bjorn@mork.no>
>
> to the 3 bugfix patches, including version 2 of patch #3.
>
>
> Bjørn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
