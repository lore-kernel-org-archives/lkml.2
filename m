Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab0JSAab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:30:31 -0400
Received: from antispam02.maxim-ic.com ([205.153.101.183]:42650 "EHLO
	antispam02.maxim-ic.com.maxim-ic.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754855Ab0JSAa3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:30:29 -0400
X-ASG-Debug-ID: 1287448228-6cb0ca8c0001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Oct 2010 17:30:39 -0700
X-ASG-Orig-Subj: RE: linux-next: build failure after merge of the sound-asoc tree
Subject: RE: linux-next: build failure after merge of the sound-asoc tree
Thread-Topic: linux-next: build failure after merge of the sound-asoc tree
Thread-Index: ActvIbnhrGtQDxy9RKydlrXuSQRBRQAAZkbQ
Message-ID: <B2150E1E4418E1438554A300EA5040E40D471A4297@ITSVLEX06.it.maxim-ic.internal>
References: <20101018142934.65f5d0fa.sfr@canb.auug.org.au>
 <B2150E1E4418E1438554A300EA5040E40D47140D97@ITSVLEX06.it.maxim-ic.internal>
 <20101019000730.GA27248@opensource.wolfsonmicro.com>
In-Reply-To: <20101019000730.GA27248@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Oct 2010 00:30:52.0225 (UTC) FILETIME=[E2A65B10:01CB6F24]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1287448228
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010, Mark Brown wrote:
> On Mon, Oct 18, 2010 at 01:25:12PM -0700, Peter Hsiang wrote:
> 
> > This message seems to be saying that this header file is missing.
> > However, this header file was included in the patch that was submitted,
> > and it did compile fine here before the submit.
> > I don't understand why it's not there after it was applied?
> 
> Your patch was apparently not generated against the mainline Makefile or
> Kconfig and the automated conflict resolution tool I used (which is
> normally fairly reliable) appears to have misplaced the header.  I've
> restored the driver with the readdition of the header.

.../pub/scm/linux/kernel/git/next/linux-next.git  Right?
Thanks!

Peter

