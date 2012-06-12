Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab2FLN7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:59:36 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:46653 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab2FLN7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:59:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIzz1202hzzz2dh668h839h93fhd25hf0ah)
X-WSS-ID: 0M5IC71-02-C1R-02
X-M-MSG: 
Date: Tue, 12 Jun 2012 15:59:25 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
CC: Borislav Petkov <bp@alien8.de>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>
Subject: Re: CPU MTRRs and linux kernel
Message-ID: <20120612135925.GJ17596@alberich.amd.com>
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com>
 <20120612103954.GB10124@x1.osrc.amd.com>
 <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 06:48:10AM -0700, Mahmood Naderan wrote:
> Thanks Borislav,

> I want to know, should I upgrade to the latest kernel or it is
> possible to download the source of 2.6.32-24 from repository and
> modify cleanup.c and then recompile?


Trying to update to latest kernel package is the first thing to do.  I
think they've provided kernels >=2.6.32-35 or so.

So chances are high that they already have picked up the fix from
2.6.32-stable tree updates.


Regards,
Andreas


