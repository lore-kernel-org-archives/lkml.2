Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0KAV1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:27:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45112 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0KAV1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:27:51 -0400
Date: Mon, 1 Nov 2010 22:27:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Peter Oruba <peter.oruba@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        amd64-microcode@amd64.org
Subject: Re: [PATCH] AMD Microcode: Prefer vzalloc() over calls to
 vmalloc()+memset()
Message-ID: <20101101212747.GA23907@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
	Peter Oruba <peter.oruba@amd.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	amd64-microcode@amd64.org
References: <alpine.LNX.2.00.1010302118160.1572@swampdragon.chaosbits.net>
 <20101031100833.GA18633@liondog.tnic>
 <alpine.LNX.2.00.1011012020500.12889@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011012020500.12889@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 08:23:23PM +0100, Jesper Juhl wrote:
> Thank you for the feedback I'll prepare a new version of the patch 
> incorporating it, then resend it. 
> 
> One thing I'm not entirely sure about though is how to credit you with 
> your improment to my original patch. Would I simply prepend
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> 
> or should I leave just my own Signed-off-by: and then mention you in the 
> changelog part of the mail or? 

How very considerate of you, but no need. Simply put your SOB in and
I'll ack it.

Thanks.

-- 
Regards/Gruss,
    Boris.
