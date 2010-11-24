Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0KXRDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:03:31 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:17428
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690Ab0KXRD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:03:29 -0500
X-SpamScore: -27
X-BigFish: VPS-27(zz542N1432N14ffO9371Pzz1202hzz8275dhz2dh95h691h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: RE: Mega rename of device tree routines from of_*() to dt_*()
Date: Wed, 24 Nov 2010 09:02:18 -0800
In-Reply-To: <1290607413.12457.44.camel@concordia>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Mega rename of device tree routines from of_*() to dt_*()
Thread-Index: AcuL4IxPnEXiFsmISpat6zMuVNPGJgAGC53g
References: <1290607413.12457.44.camel@concordia>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: <michael@ellerman.id.au>, LKML <linux-kernel@vger.kernel.org>
CC: linux-mips <linux-mips@linux-mips.org>,
        <microblaze-uclinux@itee.uq.edu.au>,
        <devicetree-discuss@lists.ozlabs.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 24 Nov 2010 17:03:22.0310 (UTC) FILETIME=[80233660:01CB8BF9]
X-RCIS-Action: ALLOW
Message-ID: <fa44e045-9600-4c46-939a-af246afab4f6@VA3EHSMHS019.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAOH3eGX013652



> -----Original Message-----
> From: linuxppc-dev-bounces+stephen=neuendorffer.name@lists.ozlabs.org [mailto:linuxppc-dev-
> bounces+stephen=neuendorffer.name@lists.ozlabs.org] On Behalf Of Michael Ellerman
> Sent: Wednesday, November 24, 2010 6:04 AM
> To: LKML
> Cc: linux-mips; microblaze-uclinux@itee.uq.edu.au; devicetree-discuss@lists.ozlabs.org; linuxppc-dev
> list; sparclinux@vger.kernel.org
> Subject: RFC: Mega rename of device tree routines from of_*() to dt_*()
> 
> Hi all,
> 
> There were some murmurings on IRC last week about renaming the of_*()
> routines. I was procrastinating at the time and said I'd have a look at
> it, so here I am.
> 
> The thinking is that on many platforms that use the of_() routines
> OpenFirmware is not involved at all, this is true even on many powerpc
> platforms. Also for folks who don't know the OpenFirmware connection it
> reads as "of", as in "a can of worms".
> 
> Personally I'm a bit ambivalent about it, the OF name is a bit wrong so
> it would be nice to get rid of, but it's a lot of churn.
> 
> So I'm hoping people with either say "YES this is a great idea", or "NO
> this is stupid".

Personally, I think it's a great idea, if only because I stared long and hard
at the code once upon a time trying to figure out what is really OF-related
and what isn't.  It's somewhat clearer now that drivers/of has been factored
out (although, shouldn't it be drivers/dt???)

That said, it *is* alot of code churn.  If it's going to be done, I think it should be
done in concert with fixing a bunch of the function names which don't really follow any
sane naming convention, so that the backporting discontinuity only happens once.

Steve

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
