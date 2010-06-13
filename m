Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0FMT6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 15:58:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51391 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab0FMT6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 15:58:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1006131103590.3964@bogon.housecafe.de>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera> <YPGdyfWGvNK.A.C8B.d9OFMB@chimera> 
	<201006131722.44062.s.L-H@gmx.de> <alpine.DEB.2.01.1006131103590.3964@bogon.housecafe.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 13 Jun 2010 13:57:40 -0600
X-Google-Sender-Auth: tDMCJfIHKCtfQkGL-kOCFq2bmuM
Message-ID: <AANLkTily7ZDG16uE2vSsq8t3mssuATwtHnr8OajX8oga@mail.gmail.com>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
To: Christian Kujau <lists@nerdbynature.de>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Michael Ellerman <michael@ellerman.id.au>, linux-media@vger.kernel.org,
       mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 12:10 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Sun, 13 Jun 2010 at 17:22, Stefan Lippers-Hollmann wrote:
>> Still existing in 2.6.34 and 2.6.35 HEAD, however a patch fixing the issue
>> for b2c2-flexcop/ flexcop-pci has been posted last week:
>
> So, now we have two patches for slightly different issues?
>
> * http://lkml.indiana.edu/hypermail/linux/kernel/1006.0/00137.html
>  ...fixes the flexcop-pci.c driver.
>
> * http://patchwork.ozlabs.org/patch/52978/
>  ...fixes "some bogus firmwares include properties with "/" in their
>  name". I'm not sure if this would make the flexcop-pci.c badness go
>  away too.
>
> Anyway, both patches are not upstream yet, but Michael mentioned that
> Grant Likely or Ben might push it eventually.

On brief review, they look like completely different issues.  I doubt
the second patch will fix the flexcop-pci issue.  I'll pick up the
device tree patch, but the flexcop-pci patch should go in by the
v4l/dvb tree.

g.
