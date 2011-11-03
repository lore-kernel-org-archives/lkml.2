Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab1KCO72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:59:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56100 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932765Ab1KCO70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:59:26 -0400
MIME-Version: 1.0
In-Reply-To: <1320331637.2813.84.camel@hp6530s>
References: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
	<20111102151711.GB12543@dhcp-172-17-108-109.mtv.corp.google.com>
	<1320330107.2813.73.camel@hp6530s>
	<CAOS58YMSwnp=Vm81+0_ZO9OYB4=NMnfETBen0QNCQwuDW0TjUA@mail.gmail.com>
	<1320331637.2813.84.camel@hp6530s>
Date: Thu, 3 Nov 2011 07:59:24 -0700
X-Google-Sender-Auth: r7xPFSSjhWBdvpRSyxsEcm5N1Kc
Message-ID: <CAOS58YM_cNXe5ZSMu-N2K02EjwyVheO2x80SoBYdrr6WgWv=dQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] ata port runtime power management support
From: Tejun Heo <tj@kernel.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 3, 2011 at 7:47 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>> > There will be ACPI firmware which supports ata port runtime D3Cold.
>> > To enable ata port runtime PM is the first step.
>>
>> libata can already turn off unused ports although it wouldn't go as
>> far as putting the whole controller into D3.
>
> At runtime?

Nope, I meant unoccupied (no device attached). IIRC it's part of the LPM code.

-- 
tejun
