Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab2FYPE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:04:58 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:49653 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab2FYPE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:04:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120611172545.GA1776@redhat.com>
References: <1339423241.4999.53.camel@lappy> <20120611144134.GX22557@sortiz-mobl>
 <1339425693.6001.2268.camel@edumazet-glaptop> <20120611145700.GY22557@sortiz-mobl>
 <1339426778.6001.2312.camel@edumazet-glaptop> <20120611152007.GZ22557@sortiz-mobl>
 <1339433810.4999.65.camel@lappy> <20120611172545.GA1776@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 25 Jun 2012 17:04:35 +0200
Message-ID: <CA+1xoqcwr-5dzHvqkt9x0-xj9EFAywVfva=asbHXvX-LSBWqdA@mail.gmail.com>
Subject: Re: net: nfc: BUG and panic in accept() on 3.5-rc2
To: Dave Jones <davej@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 7:25 PM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Jun 11, 2012 at 06:56:50PM +0200, Sasha Levin wrote:
>
>  > > > > > > What's trinity ?
>  > > > > > > Also, if this one is reproducible, would you mind sharing some details about
>  > > > > > > how we could reproduce it ?
>  > > > > >
>  > > > > > Well, bugfix should be trivial enough ;)
>  > > > > Yep, I looked at the code only after looking at Sasha's report.
>  > > > >
>  > > > > Thanks for the patch, do you mind if I add your SOB to it ?
>  > > >
>  > > > I  would prefer making sure it fixes the bug first ;)
>  > > Sure, although your patch makes sense regardless of that :)
>  > > I'll still wait for Sasha to confirm that it fixes his crash.
>  >
>  > I don't have a direct way of reproducing it, but I've put it in the test
>  > vm and the fuzzer is running, I'll let you know tomorrow if it happened
>  > again.
>
> You might be able to trigger it faster by using -P PF_NFC, which will
> force trinity to only use NFC sockets.
>
> sidenote: most protocols trigger the module to be auto-loaded when a socket
> is created. This doesn't seem to happen with nfc, making me need to manually
> modprobe it first. Intentional ?

It fixes the bug, wasn't been able to reproduce it since then.
