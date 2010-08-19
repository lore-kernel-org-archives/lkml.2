Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0HSQYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:24:25 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:40749 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0HSQYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:24:22 -0400
X-SpamScore: -35
X-BigFish: VPS-35(zzbb2dK1432N9370J98dN4015L9371P853kzz1202hzz8275bh15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L7EQVX-02-3LA-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Thu, 19 Aug 2010 18:23:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-pmfixtejun+; KDE/4.5.0; x86_64; ; )
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <AANLkTin2XPHXL_o9hHz9f4beTYEx+isX+PaFRkMMiYHQ@mail.gmail.com> <4C6B79C8.7080602@gmail.com>
In-Reply-To: <4C6B79C8.7080602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <201008191823.57915.stephan.diestelhorst@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wednesday 18 August 2010, 08:12:24 Tejun Heo wrote:
> On 08/17/2010 11:28 PM, Stephan Diestelhorst wrote:
> > 2010/8/17 Tejun Heo <htejun@gmail.com>:
> >> On 08/17/2010 12:51 PM, Stephan Diestelhorst wrote:
> >>> I've also confirmed that the "XXX ahci_set_ipm" is present in
> >>> libahci.ko. So either I've screwed up badly when compiling the initrd,
> >>> the code is not executed or the printout does not make it into any
> >>> logfile anymore.
> >>
> >> Yeah, that's weird.  You're enabling IPM, right?
>
> You can check whether it's enabled by
> 
> $ cat /sys/class/scsi_host/host0/link_power_management_policy
> 
> If it says max_performance, it's disabled.  If it says anything else,
> it's enabled.

It says "max_performance", I have not touched anyhting. So it has been
like that all the time. Would this explain why your patch did not show
the debug printout?

Thanks,
  Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

