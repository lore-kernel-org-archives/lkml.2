Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143Ab2LINYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 08:24:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58689 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934112Ab2LINYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 08:24:16 -0500
Date: Sun, 9 Dec 2012 14:24:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: John <da_audiophile@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Expand CPU compiler options
Message-ID: <20121209132413.GE24106@liondog.tnic>
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
 <20121209122907.GD24106@liondog.tnic>
 <1355057981.88866.YahooMailNeo@web140001.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355057981.88866.YahooMailNeo@web140001.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 04:59:41AM -0800, John wrote:
> My only confusion is why some of these are already included in the
> linux kernel source today, for example CORE2.  As I stated in my
> previous email, the two 'new' ones I tested preform as-good-as or
> better-than the CORE2 which is already included.  Does my confusion
> make sense?

That's a good question. Hmm, next question :-).

In any case, I've yet to see significant perf improvements to the kernel
due to it being built with specific uarch -mtune settings.

-- 
Regards/Gruss,
    Boris.
