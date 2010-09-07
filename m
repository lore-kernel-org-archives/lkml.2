Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0IGL7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 07:59:40 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:24434 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab0IGL7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 07:59:35 -0400
X-SpamScore: -45
X-BigFish: VPS-45(zz1432N9370J98dN4015L1447R9371Pzz1202hzz8275bh15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8DL2W-02-4MV-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Tejun Heo <htejun@gmail.com>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] libata: skip EH autopsy and recovery during suspend
Date: Tue, 7 Sep 2010 13:54:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-020635rc4-generic; KDE/4.5.0; x86_64; ; )
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201009021633.22869.stephan.diestelhorst@amd.com> <AANLkTi==kpbcJQ9E_MMfs9Ohu_O4vNsf8T7NK1z+iAwn@mail.gmail.com>
In-Reply-To: <AANLkTi==kpbcJQ9E_MMfs9Ohu_O4vNsf8T7NK1z+iAwn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <201009071354.32149.stephan.diestelhorst@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 September 2010, 22:52:56 I wrote:
> On Thu, Sep 2, 2010 at 4:33 PM, Stephan Diestelhorst
> <stephan.diestelhorst@amd.com> wrote:
> > On Thursday 02 September 2010, 12:02:49 Tejun Heo wrote:
> >> For some mysterious reason, certain hardware reacts badly to usual EH
> >> actions while the system is going for suspend.  As the devices won't
> >> be needed until the system is resumed, ask EH to skip usual autopsy
> >> and recovery and proceed directly to suspend.
> >
> > Thanks Tejun for this patch. Will test in a second!
> 
> Applied, compiled and worked for the 5 iterations I managed to test it.
> Much better than your previous patch, thanks a lot! I'd give it some more spins
> tomorrow, though.

Alright, I have tested for more than 20 iterations now. It works
great! Thanks for the fix!

Are there any plans for upstream inclusion?

Thanks,
  Stephan


-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

