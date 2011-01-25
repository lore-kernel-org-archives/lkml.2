Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1AYIXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:23:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55985 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1AYIXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rmJkpi1HfMo/RyAshQMRY2VBglKGVLjTY5gnJGKEGS4uB+kIQqH8QlDbVGlHCFv86w
         sPriVy55TL54PtSjt0LZdLHL/fQdt2hwm3PSnXvRO5KMYqtRGkXlZ539iYECcNn90TtF
         xFPItkF01G2x2uxEKoi+5+banQc+sWiGoB2f8=
Message-ID: <4D3E888D.60909@suse.cz>
Date: Tue, 25 Jan 2011 09:23:41 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Takashi Iwai <tiwai@suse.de>, jirislaby@gmail.com, perex@perex.cz,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] azt3328: repair breakage (Re: [PATCH 1/1] SOUND: azt3328,
 fix broken AZF_FMT_XLATE macro)
References: <1295704570-27015-1-git-send-email-jslaby@suse.cz> <s5h1v44j45c.wl%tiwai@suse.de> <20110125054631.GA10984@rhlx01.hs-esslingen.de>
In-Reply-To: <20110125054631.GA10984@rhlx01.hs-esslingen.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 06:46 AM, Andreas Mohr wrote:
> It is also quite interesting to note that this rather uncommon language syntax
> (do...while(0) within switch scope) compiled cleanly without issue
> (no warnings).

Note that the switch block is the same like the others and case and
default and very similar to goto labels. You can even do:
switch (x) {
int abc;
{ case 5: abc = 7; break; }
do { case 3: abc = 5; break; } while (0);
while (1) {
        printf("%d\n", abc);
default:
        abc = 1;
}
}
And check what it will do for x == 3, 5, and others :).

regards,
-- 
js
suse labs
