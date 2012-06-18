Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab2FRMDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:03:50 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52150 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2FRMDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:03:47 -0400
MIME-Version: 1.0
In-Reply-To: <4FDF12F0.6080205@mvista.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
	<1340000766-129148-5-git-send-email-ming.m.lin@intel.com>
	<4FDF12F0.6080205@mvista.com>
Date: Mon, 18 Jun 2012 20:03:46 +0800
X-Google-Sender-Auth: XMWjdNMAle2yY1-HF56kdha7-4Q
Message-ID: <CAF1ivSaiVGB+TSn80QijpWJWUdkhpjuOKuu9XSTROF-kGgP_gQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/12] libata: use correct PCI devices
From: Lin Ming <ming.m.lin@intel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>,
        Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 7:37 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> On 18-06-2012 10:25, Lin Ming wrote:
>
>> From: Holger Macht <holger@homac.de>
>
>
>> Commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a
>
>
>   Please also specify that commit's summary in parens.

OK.

Thanks,
Lin Ming

>
>
>> made ata ports parent
>> devices of scsi hosts, so we need to go yet another level up to be able
>> to use the correct PCI devices.
>
>
>> Signed-off-by: Holger Macht <holger@homac.de>
>> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>
>
> MBR, Sergei
