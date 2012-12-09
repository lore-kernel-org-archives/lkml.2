Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065Ab2LIM3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 07:29:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43526 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934052Ab2LIM3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 07:29:11 -0500
Date: Sun, 9 Dec 2012 13:29:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: John <da_audiophile@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Expand CPU compiler options
Message-ID: <20121209122907.GD24106@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	John <da_audiophile@yahoo.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1354745355.79857.YahooMailNeo@web140001.mail.bf1.yahoo.com>
 <20121205222738.GB6239@liondog.tnic>
 <1354748412.17691.YahooMailNeo@web140005.mail.bf1.yahoo.com>
 <20121205230835.GF6222@liondog.tnic>
 <1354968839.35825.YahooMailNeo@web140006.mail.bf1.yahoo.com>
 <20121209111857.GC24106@liondog.tnic>
 <1355054935.13447.YahooMailNeo@web140004.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355054935.13447.YahooMailNeo@web140004.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 04:08:55AM -0800, John wrote:
> While I agree that the differences as small - on the order of
> ms - they are not insignificant nor are they in the noise of the
> measurements.

Oh, maybe I wasn't clear - I wasn't talking about statistical
significance but rather about practical significance.

A minuscule speedup (a lot less than 1%) showing only in a *single*
workload so far and relevant only for a *very* *small* number of linux
users - only those who build their own kernels - is simply not worth
including in the kernel.

-- 
Regards/Gruss,
    Boris.
