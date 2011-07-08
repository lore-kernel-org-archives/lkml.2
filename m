Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1GHH2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:28:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46882 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1GHH2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:28:33 -0400
Reply-To: <tommy.lin@caviumnetworks.com>
From: Tommy Lin <tommy.lin.1101@gmail.com>
To: "'Anton Vorontsov'" <cbouatmailru@gmail.com>
Cc: "'Tommy Lin'" <tommy.lin.1101@gmail.com>,
        "'Wim Van Sebroeck'" <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Lin, Mac" <Mac.Lin@caviumnetworks.com>
References: <1309867548-7842-1-git-send-email-tommy.lin@caviumnetworks.com> <20110705140559.GA15771@oksana.dev.rtsoft.ru> <281B1F8BAB4D4BDABE7568809A0AEC1A@starsemi.com> <20110706111616.GA18967@oksana.dev.rtsoft.ru> <20110706112830.GA23184@oksana.dev.rtsoft.ru> <20110706114629.GA32659@oksana.dev.rtsoft.ru> <6D7FCE1DF69D524D850E799960F2705811271D@caexch01.caveonetworks.com> <20110706193457.GA20378@oksana.dev.rtsoft.ru>
Subject: RE: [PATCH 2/2] watchdog: mpcore_wdt Add reload value setting for CNS3xxx hardware
Date: Fri, 8 Jul 2011 15:28:05 +0800
Organization: CHOG
Message-ID: <CE02B12FB1A04C32A691217E8DA7B69E@starsemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acw8E8yB+EXH4h9xRHSmPdEx5P3PDABJGK0Q
In-Reply-To: <20110706193457.GA20378@oksana.dev.rtsoft.ru>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I submit another patch that can solve the warning.
[PATCH 1/2] arch: arm: Correct the dependency of HAVE_ARM_TWD
This patch should after above one.

Should I submit another patch or just attach it in this thread?

Best regards,
Tommy Lin

-----Original Message-----
From: Anton Vorontsov [mailto:cbouatmailru@gmail.com] 
Sent: Thursday, July 07, 2011 3:35 AM
To: Lin, Tommy
Cc: Tommy Lin; Wim Van Sebroeck; linux-watchdog@vger.kernel.org;
linux-kernel@vger.kernel.org; Lin, Mac
Subject: Re: [PATCH 2/2] watchdog: mpcore_wdt Add reload value setting for
CNS3xxx hardware

On Wed, Jul 06, 2011 at 07:54:49AM -0700, Lin, Tommy wrote:
> I am thinking that mpcore_wdt should work even SMP is not turned on. Did
the dependency 
> is neccesarry between mpcore_wdt and SMP? If CPU1 is turned off the
mpcore_wdt worked
> well with CPU0 only.

No doubt that the watchdog itself works fine. :-) But the point is
that the patch yields a warning, so it should be fixed before merging.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

