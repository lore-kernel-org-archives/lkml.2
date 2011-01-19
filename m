Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1ASRn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:43:28 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4268 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab1ASRn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:43:27 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Jon Masters" <jcm@redhat.com>, "Brett Rudley" <brudley@broadcom.com>
cc: devel <devel@linuxdriverproject.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Jan 2011 09:43:18 -0800
Subject: RE: PROBLEM: brcm80211 unable to survive suspend/resume cycle
Thread-Topic: PROBLEM: brcm80211 unable to survive suspend/resume cycle
Thread-Index: Acu3/E/L9VGQ0NG/RQ6Sn0Z2t6BDHQAAKdiP
Message-ID: <400C43189542CE41BC0A5B252FC90136952F059547@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
 <7A94256FD72B884D9E7C55586C3CBCEE13840C62AA@SJEXCHCCR01.corp.ad.broadcom.com>
 <1289880279.3916.889.camel@constitution.bos.jonmasters.org>
 <1293028287.6319.171.camel@constitution.bos.jonmasters.org>,<1295457365.9781.108.camel@constitution.bos.jonmasters.org>
In-Reply-To: <1295457365.9781.108.camel@constitution.bos.jonmasters.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6129FC8D3H04432611-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

I tried to give you a heads up. I submitted the patch last friday to the staging-2.6 repository. Not sure whether it has propagated to the 2.6.3[78] kernels yet.

Gr. AvS
________________________________________
From: devel-bounces@linuxdriverproject.org [devel-bounces@linuxdriverproject.org] On Behalf Of Jon Masters [jcm@redhat.com]
Sent: Wednesday, January 19, 2011 6:16 PM
To: Brett Rudley
Cc: devel; Linux Kernel Mailing List
Subject: RE: PROBLEM: brcm80211 unable to survive suspend/resume cycle

On Wed, 2010-12-22 at 09:31 -0500, Jon Masters wrote:
> On Mon, 2010-11-15 at 23:04 -0500, Jon Masters wrote:
> > On Tue, 2010-11-09 at 10:02 -0800, Brett Rudley wrote:
> > > Hey Jon, thanks for the heads up.  I can repro and am looking into it.
> >
> > Did you get chance to poke much yet?
>
> Any word on this?

Any update? I know one of your guys was looking into it?

Also, congrats on becoming LF members. That's awesome.

Jon.


_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/devel


