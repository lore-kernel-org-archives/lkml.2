Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2FLN5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:57:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60700 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab2FLN5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:57:15 -0400
Date: Tue, 12 Jun 2012 15:57:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: CPU MTRRs and linux kernel
Message-ID: <20120612135713.GA10128@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mahmood Naderan <nt_mahmood@yahoo.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com>
 <20120612103954.GB10124@x1.osrc.amd.com>
 <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 06:48:10AM -0700, Mahmood Naderan wrote:
> Thanks Borislav, I want to know, should I upgrade to the latest kernel
> or it is possible to download the source of 2.6.32-24 from repository
> and modify cleanup.c and then recompile?

Whatever you decide.

If it were me and I didn't have any particular reason to stick with
2.6.32, I'd always go for the latest kernel.

In any case, no matter which kernel you're installing, just make sure it
contains the aforementioned patch which should fix your problem.

HTH.

-- 
Regards/Gruss,
Boris.
