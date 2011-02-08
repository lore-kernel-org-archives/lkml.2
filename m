Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1BHH1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 02:27:09 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:42965 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1BHH1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 02:27:07 -0500
From: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 8 Feb 2011 07:24:54 +0000
Subject: RE: Block IO throttling disabled in distros
Thread-Topic: Block IO throttling disabled in distros
Thread-Index: AcvG4N3IZCbo5WBAR+SMdegiDCrzqQAgAzvA
Message-ID: <59DD1BA8FD3C0F4C90771C18F2B5B53A653FF72FB5@GVW0432EXB.americas.hpqcorp.net>
References: <59DD1BA8FD3C0F4C90771C18F2B5B53A653FF7284B@GVW0432EXB.americas.hpqcorp.net>
 <20110207160451.GH7437@redhat.com>
In-Reply-To: <20110207160451.GH7437@redhat.com>
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

> On Mon, Feb 07, 2011 at 03:33:38PM +0000, Haefliger, Juerg wrote:
> > Hi,
> >
> > Both RHEL6 and Ubuntu 10.10 have block IO throttling disabled in
> their kernels. Does anybody know why that is? Are there performance or
> stability issues with the throttling controller or does it somehow
> negatively interfere with the rest of the kernel and/or system?
> 
> Block IO throttling support was not even upstream at that time hence
> you don't see it.

Duh! I thought I checked that the code was there but just not enabled. I just double-checked and sure enough block IO throttling is not in the RHEL6 kernel source. Sorry for the noise.

Thanks
...Juerg


> I have not heard about any stability issues so far. Of course more
> testing will reveal that.
> 
> The only thing I have thinking is that should we limit the number of
> bios queued per IO context on the device. Currently there is no such limit
> and one can queue up as many bios as one want to.
>
>
> Thanks
> Vivek
