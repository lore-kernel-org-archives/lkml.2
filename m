Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1AGCwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:52:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11265 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1AGCwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:52:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Thu, 06 Jan 2011 18:51:31 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Randy Dunlap'" <rdunlap@xenotime.net>, Jesper Juhl <jj@chaosbits.net>
CC: "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Thu, 6 Jan 2011 18:49:45 -0800
Subject: RE: [PATCH v2] input: tegra-kbc - Add tegra keyboard driver
Thread-Topic: [PATCH v2] input: tegra-kbc - Add tegra keyboard driver
Thread-Index: Acut8OjZJMwLpo61QcymiD88R6xvRQAJD4ng
Message-ID: <1FC56210173BB445BD77F608D6FB8D03165A008053@HQMAIL03.nvidia.com>
References: <1294351512-17035-1-git-send-email-riyer@nvidia.com>
	<alpine.LNX.2.00.1101062311340.13988@swampdragon.chaosbits.net>
 <20110106142714.f823dea8.rdunlap@xenotime.net>
In-Reply-To: <20110106142714.f823dea8.rdunlap@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On
> Behalf Of Randy Dunlap
> Sent: Thursday, January 06, 2011 2:27 PM
> To: Jesper Juhl
> Cc: Rakesh Iyer; tsoni@codeaurora.org; shubhrajyoti@ti.com; ccross@android.com;
> konkers@android.com; olof@lixom.net; Andrew Chew; linux-tegra@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-input@vger.kernel.org
> Subject: Re: [PATCH v2] input: tegra-kbc - Add tegra keyboard driver
> 
> On Thu, 6 Jan 2011 23:15:01 +0100 (CET) Jesper Juhl wrote:
> 
> > > +fail:
> > > +	if (kbc->irq >= 0)
> > > +		free_irq(kbc->irq, pdev);
> > > +	if (kbc->idev)
> > > +		input_free_device(kbc->idev);
> >
> > As far as I can tell input_free_device() deals gracefully with being
> > passed a null pointer, so the 'if' seems superfluous.
> >
> >
> > --
> > Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> > Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> > Plain text mails only, please.
> + Please trim replies to the relevant part(s) of patches.
> 
> 
> thnx,
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Is having this check really an issue? 
Can't input_free_device change in the future so that NULL as a parameter does cause undesirable side-effects?

Regards
Rakesh
