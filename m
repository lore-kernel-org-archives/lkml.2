Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2ACAUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:20:04 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31682 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2ACAUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:20:02 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzz8275dhz2fh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-FB-SS: 0,
From: KY Srinivasan <kys@microsoft.com>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "wfp5p@virginia.edu" <wfp5p@virginia.edu>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "valdis.kletnieks@vt.edu" <valdis.kletnieks@vt.edu>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jj@chaosbits.net" <jj@chaosbits.net>,
        "joe@perches.com" <joe@perches.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
Subject: RE: [PATCH 6/6] Staging: comedi: fix initialise statics to 0 or
 NULL	issue in ni_mio_cs.c.
Thread-Topic: [PATCH 6/6] Staging: comedi: fix initialise statics to 0 or
 NULL	issue in ni_mio_cs.c.
Thread-Index: AQHMyVjquVH4eaQLDUSI6nds6j8iIJX5x90A
Date: Tue, 3 Jan 2012 00:19:56 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B2F0317@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1325510273-20091-1-git-send-email-ravishankar.km@greenturtles.in>
In-Reply-To: <1325510273-20091-1-git-send-email-ravishankar.km@greenturtles.in>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel-bounces@linuxdriverproject.org [mailto:devel-
> bounces@linuxdriverproject.org] On Behalf Of Ravishankar karkala
> Mallikarjunayya
> Sent: Monday, January 02, 2012 8:18 AM
> To: gregkh@suse.de; wfp5p@virginia.edu
> Cc: devel@driverdev.osuosl.org; valdis.kletnieks@vt.edu; rmallon@gmail.com;
> linux-kernel@vger.kernel.org; jj@chaosbits.net; joe@perches.com;
> dan.carpenter@oracle.com; Ravishankar karkala Mallikarjunayya
> Subject: [PATCH 6/6] Staging: comedi: fix initialise statics to 0 or NULL issue in
> ni_mio_cs.c.
> 
> This is a patch to the ni_mio_cs.c file that fixes up a initialise
> statics to 0 or NULL warning found by the checkpatch.pl tool.
> 
> Breaks the build.

Why would you submit a patch that breaks the build?

K. Y

