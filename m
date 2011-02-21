Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1BUQpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:45:22 -0500
Received: from mailgw04.flightsafety.com ([66.109.93.21]:60847 "EHLO
	mailgw04.flightsafety.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1BUQpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:45:20 -0500
From: "Underwood, Ryan" <Ryan.Underwood@flightsafety.com>
To: Preeti Khurana <Preeti.Khurana@guavus.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Feb 2011 10:45:11 -0600
Subject: RE: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Thread-Topic: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Thread-Index: AQHLz4ae2JLynF6uRE27oMuWeWEFPpQHXDyAgAQu4DCAAKJWIA==
Message-ID: <4FE5E7F6EBBC274ABEE8E2DDB69E6DBF33970A4B8E@srv060ex01.ssd.fsi.com>
References: <9F0C2539CB50A743894F8FCEEB1D569206F4A5@mx1.guavus.com>
 <loom.20110217T003826-785@post.gmane.org>
 <AANLkTikEMOxtTe7afmYsvyQkJi7j70TRX3cPPR0X=uQj@mail.gmail.com>
 <20110218024055.GA2237@linux.vnet.ibm.com>
 <4FE5E7F6EBBC274ABEE8E2DDB69E6DBF33970A4AF0@srv060ex01.ssd.fsi.com>
 <9F0C2539CB50A743894F8FCEEB1D56920714B3@mx1.guavus.com>
In-Reply-To: <9F0C2539CB50A743894F8FCEEB1D56920714B3@mx1.guavus.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 21 Feb 2011 16:45:14.0465 (UTC) FILETIME=[B67EFD10:01CBD1E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Since a previous BIOS version is known to work I may end up having to do
> > some BIOS-bisecting today...
> 
> Ryan,
>    Cant say that this patch (https://lkml.org/lkml/2011/1/6/131) worked
> for me since I am not able to reproduce the problem quite reliably and now
> not getting the problem even under the original kernel without this patch.
> Just wondering what triggers this problem.

I found that even with downgrading to the same BIOS as the working systems,
the problem on the newer SR2500 systems remains!  There must have been a
recent change in the hardware causing this, or some arcane BIOS setting
that I am overlooking.  I still need to rule out our PCI hardware as the
source of the problem, since PCI parity errors seem to be a usual source
of NMIs, but I thought there would be a standard error code in that case...

