Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1AJTV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:21:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65410 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1AJTV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:21:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cqbo7rllSPM7gk2+0fwp3z3wiOytMnDV5txfOro02osR3lzGH3pcqxEPp4oOrAFyeL
         B+m6C5Dgnte7ptC5f+JUYLswzfGONFlp8FEPJ386hQTO2OCy/YrROKGwc/3Q2IbY5HoO
         Wh0ECjX/R6ROQZc3EsTHJ4MBaRrbF42STjAoc=
Message-ID: <4D2B5C4F.1090701@suse.cz>
Date: Mon, 10 Jan 2011 20:21:51 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, werner@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: move proc_console.c to fs/proc/consoles.c
References: <20110108173526.GA21042@p183.telecom.by>
In-Reply-To: <20110108173526.GA21042@p183.telecom.by>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2011 06:35 PM, Alexey Dobriyan wrote:
> Filename is supposed to match procfile name for random junk.
> 
> Add __init while I'm at it.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  fs/proc/Makefile       |    2 
>  fs/proc/consoles.c     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/proc/proc_console.c |  114 -------------------------------------------------
>  3 files changed, 115 insertions(+), 115 deletions(-)

ACK.

thanks,
-- 
js
suse labs
