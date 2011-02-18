Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab1BRUos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:44:48 -0500
Received: from mailgw03.flightsafety.com ([66.109.93.20]:51356 "EHLO
	mailgw03.flightsafety.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab1BRUop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:44:45 -0500
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Feb 2011 15:44:45 EST
From: "Underwood, Ryan" <Ryan.Underwood@flightsafety.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Preeti Khurana <Preeti.Khurana@guavus.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Feb 2011 14:38:05 -0600
Subject: RE: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Thread-Topic: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Thread-Index: AcvPhzjtQJTaR0VuT6+5aitI+Yg3dQAI9ysg
Message-ID: <4FE5E7F6EBBC274ABEE8E2DDB69E6DBF33970A4AF0@srv060ex01.ssd.fsi.com>
References: <9F0C2539CB50A743894F8FCEEB1D569206F4A5@mx1.guavus.com>
 <loom.20110217T003826-785@post.gmane.org>
 <AANLkTikEMOxtTe7afmYsvyQkJi7j70TRX3cPPR0X=uQj@mail.gmail.com>
 <20110218024055.GA2237@linux.vnet.ibm.com>
In-Reply-To: <20110218024055.GA2237@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Feb 2011 20:38:07.0245 (UTC) FILETIME=[BFAEC3D0:01CBCFAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Given 2.6.35, has anyone tried applying the following patch?
> 
> 	https://patchwork.kernel.org/patch/23985/
> 
> It turned out to resolve an otherwise mysterious RCU CPU stall warning
> for someone running 2.6.36, IIRC.
> 

Now I've tried 2.6.38-rc5 which already includes that patch, and the
same problems remain.  It also includes the following patch that Preeti
seems to have had some success with on 2.6.35, so my problem must really
be elsewhere:
https://lkml.org/lkml/2011/1/6/131

Since a previous BIOS version is known to work I may end up having to
do some BIOS-bisecting today...

