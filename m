Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2HCJol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:44:41 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6173 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2HCJoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:44:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 03 Aug 2012 02:44:37 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "Pandita, Vikram" <vikram.pandita@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Date: Fri, 3 Aug 2012 15:14:32 +0530
Subject: RE: [PATCH v2] printk: add option to print cpu id
Thread-Topic: [PATCH v2] printk: add option to print cpu id
Thread-Index: Ac1xW4dDRkkth7glR7+SIabHX2HJAwAAIs0A
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDCAC49BB@BGMAIL02.nvidia.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AB@BGMAIL02.nvidia.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AE@BGMAIL02.nvidia.com>
 <CAFm5wm2Z+FyVqG5oMWiEmZ8Je88hJ-cyDXmJw0wp4mqA-X9eYg@mail.gmail.com>
In-Reply-To: <CAFm5wm2Z+FyVqG5oMWiEmZ8Je88hJ-cyDXmJw0wp4mqA-X9eYg@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Pandita, Vikram [mailto:vikram.pandita@ti.com]
> Sent: Friday, August 03, 2012 3:07 PM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; kay@vrfy.org; linux-
> kernel@vger.kernel.org; Mike Turquette; Vimarsh Zutshi
> Subject: Re: [PATCH v2] printk: add option to print cpu id
> 
> Venu
> 
> On Fri, Aug 3, 2012 at 2:32 AM, Venu Byravarasu <vbyravarasu@nvidia.com>
> wrote:
> 
> To gain insight on SMP system logging behavior, the price to pay is
> the extra 4 chars per printk line,
> just like printk-time adds 15 chars to each line. Both options can be
> disabled as desired.
> 
> So i am not sure what kind of option you are proposing?

May be I'm not correct, but IMO having local file level macros to 
add wrappers on top of printk would serve this purpose. 

Anyways its individual choice.

> Do u imply PRINTK_TIME is not right then?
> 
> >
> >> Is it not better to have macros which will have wrapper to printk with
> >> required
> >> debug info added? E.g. cpu# in your case.
> >> If by default we add cupid, is it not over head in each message getting
> >> printed with printk?
> >>
> >> >
> >> > Known limitation is if the system gets preempted between function call
> and
> >> > actual printk, the reported cpu-id might not be accurate. But most of the
> >> > times its seen to give a good feel of how the N cpu's in the system are
> >> > getting loaded.
> >> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
