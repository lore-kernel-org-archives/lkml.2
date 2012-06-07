Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab2FGEKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:10:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43189 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2FGEK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FCFA17F.3050207@freescale.com>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
	<1336737235-15370-4-git-send-email-chenhui.zhao@freescale.com>
	<4FC93D74.3090200@freescale.com>
	<20120604113609.GC20676@localhost.localdomain>
	<4FCD3E8B.30805@freescale.com>
	<94F013E7935FF44C83EBE7784D62AD3F09335D27@039-SN2MPN1-022.039d.mgd.msft.net>
	<4FCE2FB8.9080307@freescale.com>
	<94F013E7935FF44C83EBE7784D62AD3F093360C1@039-SN2MPN1-022.039d.mgd.msft.net>
	<4FCE4A5A.3020603@freescale.com>
	<CADRPPNSzTNPkNExBnNu1iD2hqyRG=Cw+y+PnjTRWxjP_ib1Kww@mail.gmail.com>
	<4FCFA17F.3050207@freescale.com>
Date: Thu, 7 Jun 2012 12:10:28 +0800
X-Google-Sender-Auth: GpXgxZAOb5FMQqAbly89AgAT9AU
Message-ID: <CADRPPNS3riBaC_onHKAFn2X_tnW5Z0=a2zyxfZy1f77oEe2Jbw@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup event source
From: Li Yang <leoli@freescale.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Wood Scott-B07421 <B07421@freescale.com>,
        Li Yang-R58472 <r58472@freescale.com>,
        Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 2:29 AM, Scott Wood <scottwood@freescale.com> wrote:
> On 06/05/2012 11:06 PM, Li Yang wrote:
>> On Wed, Jun 6, 2012 at 2:05 AM, Scott Wood <scottwood@freescale.com> wrote:
>>> You ignored "what about devices other than ethernet".
>>
>> No, I haven't.  Other devices are so at least for now.
>
> I don't understand that last sentence.  Other devices are what?

Probably I misunderstood your question "what about devices other than
ethernet".  Did you mean how would other devices other than ethernet
know how to set it?

Other wakeup capable devices can call the API when it is up and
running.  It will be the pmc driver's responsibility to find out if
that specific device can be configured as a wakeup source for the SoC.

Leo
