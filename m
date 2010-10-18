Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab0JRUYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:24:41 -0400
Received: from antispam02.maxim-ic.com ([205.153.101.183]:53361 "EHLO
	antispam02.maxim-ic.com.maxim-ic.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756250Ab0JRUYk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:24:40 -0400
X-ASG-Debug-ID: 1287433480-6caeaa340001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Oct 2010 13:25:12 -0700
X-ASG-Orig-Subj: RE: linux-next: build failure after merge of the sound-asoc tree
Subject: RE: linux-next: build failure after merge of the sound-asoc tree
Thread-Topic: linux-next: build failure after merge of the sound-asoc tree
Thread-Index: ActudMcSaRxcrltrS46MWBst//AmkQAi/n8w
Message-ID: <B2150E1E4418E1438554A300EA5040E40D47140D97@ITSVLEX06.it.maxim-ic.internal>
References: <20101018142934.65f5d0fa.sfr@canb.auug.org.au>
In-Reply-To: <20101018142934.65f5d0fa.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Oct 2010 20:25:03.0147 (UTC) FILETIME=[8B83A7B0:01CB6F02]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1287433480
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> sound/soc/codecs/max98088.c:28:28: error: sound/max98088.h: No such file or
> directory
> 

Mark, 

This message seems to be saying that this header file is missing.
However, this header file was included in the patch that was submitted,
and it did compile fine here before the submit.
I don't understand why it's not there after it was applied?

Thanks,

Peter

