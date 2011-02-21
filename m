Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1BUHBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 02:01:30 -0500
Received: from mx1.guavus.com ([204.232.241.167]:11209 "EHLO mx1.guavus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab1BUHB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 02:01:29 -0500
From: Preeti Khurana <Preeti.Khurana@guavus.com>
To: "Underwood, Ryan" <Ryan.Underwood@flightsafety.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Thread-Topic: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Thread-Index: AQHLz4ae2JLynF6uRE27oMuWeWEFPpQHXDyAgAQu4DA=
Date: Mon, 21 Feb 2011 06:56:44 +0000
Message-ID: <9F0C2539CB50A743894F8FCEEB1D56920714B3@mx1.guavus.com>
References: <9F0C2539CB50A743894F8FCEEB1D569206F4A5@mx1.guavus.com>
 <loom.20110217T003826-785@post.gmane.org>
 <AANLkTikEMOxtTe7afmYsvyQkJi7j70TRX3cPPR0X=uQj@mail.gmail.com>
 <20110218024055.GA2237@linux.vnet.ibm.com>
 <4FE5E7F6EBBC274ABEE8E2DDB69E6DBF33970A4AF0@srv060ex01.ssd.fsi.com>
In-Reply-To: <4FE5E7F6EBBC274ABEE8E2DDB69E6DBF33970A4AF0@srv060ex01.ssd.fsi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Given 2.6.35, has anyone tried applying the following patch?
> >
> > 	https://patchwork.kernel.org/patch/23985/
> >
> > It turned out to resolve an otherwise mysterious RCU CPU stall warning
> > for someone running 2.6.36, IIRC.
> >
> 
	This fix is already in 2.6.35, so this doesn't seem to be an issue.

> Now I've tried 2.6.38-rc5 which already includes that patch, and the same
> problems remain.  It also includes the following patch that Preeti seems to
> have had some success with on 2.6.35, so my problem must really be
> elsewhere:
> https://lkml.org/lkml/2011/1/6/131
> 
> Since a previous BIOS version is known to work I may end up having to do
> some BIOS-bisecting today...

Ryan,
   Cant say that this patch (https://lkml.org/lkml/2011/1/6/131) worked for me since I am not able to reproduce the problem quite reliably and now not getting the problem even under the original kernel without this patch.  Just wondering what triggers this problem.

